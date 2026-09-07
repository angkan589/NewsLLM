#!/usr/bin/env python3
"""Discover recent newspaper links and run the NewsLLM content generator."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from urllib.parse import urljoin, urlparse, urlunparse

import httpx
from bs4 import BeautifulSoup


DEFAULT_PROJECT_ID = "newsllm-21fad"
DEFAULT_CONFIG = Path(__file__).with_name("news_sources.json")
GENERATOR = Path(__file__).with_name("generate_news_content.py")
USER_AGENT = (
    "Mozilla/5.0 (compatible; NewsLLM/1.0; "
    "+https://github.com/angkan589/NewsLLM)"
)


@dataclass(frozen=True)
class SourceConfig:
    slug: str
    name: str
    home_url: str
    allowed_hosts: tuple[str, ...]
    article_patterns: tuple[re.Pattern[str], ...]
    excluded_paths: tuple[str, ...]
    source_language: str


@dataclass(frozen=True)
class ArticleLink:
    title: str
    url: str


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Discover recent articles from configured newspaper homepages and "
            "process a small daily batch with the NewsLLM generator."
        )
    )
    parser.add_argument("--config", type=Path, default=DEFAULT_CONFIG)
    parser.add_argument(
        "--max-articles",
        type=int,
        default=3,
        help="Maximum successfully processed articles across all sources.",
    )
    parser.add_argument(
        "--per-source",
        type=int,
        default=1,
        help="Maximum successfully processed articles per source.",
    )
    parser.add_argument(
        "--source",
        action="append",
        default=[],
        help="Only use this configured source slug; may be repeated.",
    )
    parser.add_argument(
        "--discover-only",
        action="store_true",
        help="Print discovered links without calling Gemini or Firestore.",
    )
    parser.add_argument(
        "--publish",
        action="store_true",
        help="Publish generated articles; otherwise generate previews only.",
    )
    parser.add_argument(
        "--yes",
        action="store_true",
        help="Required with --publish for non-interactive batch publishing.",
    )
    parser.add_argument("--project-id", default=DEFAULT_PROJECT_ID)
    parser.add_argument("--model")
    args = parser.parse_args()

    if args.max_articles < 1 or args.max_articles > 10:
        parser.error("--max-articles must be between 1 and 10.")
    if args.per_source < 1 or args.per_source > 5:
        parser.error("--per-source must be between 1 and 5.")
    if args.publish and not args.yes:
        parser.error("--publish requires --yes in batch mode.")
    if args.yes and not args.publish:
        parser.error("--yes is only valid together with --publish.")
    return args


def require_string(item: dict[str, object], key: str, source_index: int) -> str:
    value = item.get(key)
    if not isinstance(value, str) or not value.strip():
        raise ValueError(f"Source {source_index} requires a non-empty {key!r}.")
    return value.strip()


def string_list(
    item: dict[str, object],
    key: str,
    source_index: int,
) -> tuple[str, ...]:
    value = item.get(key)
    if not isinstance(value, list) or not value:
        raise ValueError(f"Source {source_index} requires a non-empty {key!r} list.")
    if any(not isinstance(entry, str) or not entry.strip() for entry in value):
        raise ValueError(f"Source {source_index} has an invalid {key!r} entry.")
    return tuple(entry.strip() for entry in value)


def load_sources(path: Path) -> list[SourceConfig]:
    if not path.is_file():
        raise ValueError(f"Source configuration not found: {path}")
    try:
        raw_sources = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as error:
        raise ValueError(f"Invalid source configuration JSON: {error}") from error
    if not isinstance(raw_sources, list) or not raw_sources:
        raise ValueError("Source configuration must contain a non-empty JSON list.")

    sources: list[SourceConfig] = []
    for index, raw_source in enumerate(raw_sources, start=1):
        if not isinstance(raw_source, dict):
            raise ValueError(f"Source {index} must be a JSON object.")
        if raw_source.get("enabled", True) is not True:
            continue
        patterns = string_list(raw_source, "articlePatterns", index)
        try:
            compiled_patterns = tuple(re.compile(pattern) for pattern in patterns)
        except re.error as error:
            raise ValueError(f"Source {index} has an invalid article pattern.") from error

        source_language = str(raw_source.get("sourceLanguage", "English"))
        if source_language not in {"English", "Bangla"}:
            raise ValueError(
                f"Source {index} sourceLanguage must be English or Bangla."
            )
        excluded = raw_source.get("excludedPaths", [])
        if not isinstance(excluded, list) or any(
            not isinstance(value, str) for value in excluded
        ):
            raise ValueError(f"Source {index} has invalid excludedPaths.")

        sources.append(
            SourceConfig(
                slug=require_string(raw_source, "slug", index),
                name=require_string(raw_source, "name", index),
                home_url=require_string(raw_source, "homeUrl", index),
                allowed_hosts=string_list(raw_source, "allowedHosts", index),
                article_patterns=compiled_patterns,
                excluded_paths=tuple(excluded),
                source_language=source_language,
            )
        )
    if not sources:
        raise ValueError("No enabled news sources were found.")
    return sources


def canonical_url(base_url: str, href: str) -> str | None:
    absolute = urljoin(base_url, href.strip())
    parsed = urlparse(absolute)
    if parsed.scheme != "https" or not parsed.hostname:
        return None
    return urlunparse((parsed.scheme, parsed.netloc, parsed.path, "", "", ""))


def looks_like_article(source: SourceConfig, url: str) -> bool:
    parsed = urlparse(url)
    hostname = (parsed.hostname or "").lower()
    allowed_hosts = {value.lower() for value in source.allowed_hosts}
    if hostname not in allowed_hosts:
        return False
    normalized_path = parsed.path.rstrip("/") or "/"
    if any(normalized_path.startswith(path) for path in source.excluded_paths):
        return False
    return any(pattern.search(normalized_path) for pattern in source.article_patterns)


def discover_links(source: SourceConfig) -> list[ArticleLink]:
    try:
        with httpx.Client(
            follow_redirects=True,
            timeout=20,
            headers={"User-Agent": USER_AGENT},
        ) as client:
            response = client.get(source.home_url)
            response.raise_for_status()
    except httpx.HTTPError as error:
        raise ValueError(f"Could not load {source.name}: {error}") from error

    if len(response.content) > 5_000_000:
        raise ValueError(f"{source.name} homepage exceeded the 5 MB safety limit.")

    soup = BeautifulSoup(response.text, "html.parser")
    selectors = "main h1 a, main h2 a, main h3 a, article a, h1 a, h2 a, h3 a"
    links: list[ArticleLink] = []
    seen: set[str] = set()
    for anchor in soup.select(selectors):
        href = anchor.get("href")
        if not isinstance(href, str):
            continue
        title = re.sub(r"\s+", " ", anchor.get_text(" ", strip=True)).strip()
        if len(title) < 20 or len(title) > 220:
            continue
        url = canonical_url(str(response.url), href)
        if url is None or url in seen or not looks_like_article(source, url):
            continue
        seen.add(url)
        links.append(ArticleLink(title=title, url=url))
    return links


def generator_command(
    args: argparse.Namespace,
    source: SourceConfig,
    article: ArticleLink,
) -> list[str]:
    command = [
        sys.executable,
        str(GENERATOR),
        "--article-url",
        article.url,
        "--source-name",
        source.name,
        "--source-language",
        source.source_language,
        "--project-id",
        args.project_id,
    ]
    if args.model:
        command.extend(("--model", args.model))
    if args.publish:
        command.extend(("--publish", "--yes"))
    return command


def process_article(
    args: argparse.Namespace,
    source: SourceConfig,
    article: ArticleLink,
) -> tuple[str, str]:
    result = subprocess.run(
        generator_command(args, source, article),
        capture_output=True,
        text=True,
        check=False,
    )
    output = "\n".join(
        value.strip() for value in (result.stdout, result.stderr) if value.strip()
    )
    if result.returncode == 0:
        return "processed", output
    if "already exists" in output:
        return "duplicate", output
    return "failed", output


def run_pipeline(args: argparse.Namespace) -> int:
    sources = load_sources(args.config)
    selected = set(args.source)
    if selected:
        known = {source.slug for source in sources}
        unknown = sorted(selected - known)
        if unknown:
            raise ValueError(f"Unknown source slug(s): {', '.join(unknown)}")
        sources = [source for source in sources if source.slug in selected]

    processed = 0
    duplicates = 0
    failures: list[str] = []
    for source in sources:
        if processed >= args.max_articles:
            break
        print(f"\nDiscovering {source.name}...")
        try:
            links = discover_links(source)
        except ValueError as error:
            failures.append(str(error))
            print(f"  Error: {error}")
            continue

        print(f"  Found {len(links)} candidate article(s).")
        if not links:
            failures.append(
                f"No matching article links were discovered for {source.name}."
            )
            continue
        if args.discover_only:
            for article in links[:5]:
                print(f"  - {article.title}\n    {article.url}")
            continue

        source_processed = 0
        for article in links[:10]:
            if processed >= args.max_articles or source_processed >= args.per_source:
                break
            print(f"\nProcessing: {article.title}")
            status, output = process_article(args, source, article)
            if status == "duplicate":
                duplicates += 1
                print("  Already in Firestore; trying the next article.")
                continue
            if status == "failed":
                failures.append(f"{article.url}: {output}")
                print(f"  Failed: {output}")
                continue

            processed += 1
            source_processed += 1
            print(output)

    mode = "discovery" if args.discover_only else "publishing" if args.publish else "preview"
    print("\nDaily pipeline summary:")
    print(f"  Mode: {mode}")
    print(f"  Processed: {processed}")
    print(f"  Existing articles skipped: {duplicates}")
    print(f"  Failures: {len(failures)}")

    if failures:
        print("\nFailures:")
        for failure in failures:
            print(f"  - {failure}")
    if args.discover_only:
        return 0
    return 1 if failures else 0


def main() -> int:
    args = parse_arguments()
    try:
        return run_pipeline(args)
    except ValueError as error:
        print(f"Error: {error}", file=sys.stderr)
        return 1
    except KeyboardInterrupt:
        print("\nCancelled.", file=sys.stderr)
        return 130


if __name__ == "__main__":
    raise SystemExit(main())
