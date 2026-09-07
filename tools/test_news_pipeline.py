import json
import re
import unittest

from tools.daily_news_pipeline import (
    SourceConfig,
    canonical_url,
    is_candidate_rejection,
    looks_like_article,
)
from tools.generate_news_content import (
    extract_article_html,
    infer_category,
    normalize_publication_date,
    validate_public_url,
)


class ArticleExtractionTests(unittest.TestCase):
    def test_extracts_json_ld_article_and_metadata(self):
        body = (
            "Bangladesh hosted a national policy forum in Dhaka. "
            "Government officials, researchers, development partners and "
            "community organisations discussed practical urban governance. "
            "The two-day programme focused on applying an existing national "
            "policy through cooperation between public institutions and cities."
        )
        html = f"""
        <html lang="en">
          <head>
            <meta property="og:site_name" content="Example News">
            <script type="application/ld+json">
              {{
                "@type": "NewsArticle",
                "headline": "National policy forum opens in Dhaka",
                "datePublished": "2026-09-07T08:00:00+06:00",
                "articleSection": "Bangladesh",
                "publisher": {{"name": "Example News"}},
                "articleBody": {json.dumps(body)}
              }}
            </script>
          </head>
        </html>
        """

        result = extract_article_html(
            html,
            "https://example.com/bangladesh/news/article-123456",
        )

        self.assertEqual(result.text, body)
        self.assertEqual(result.headline, "National policy forum opens in Dhaka")
        self.assertEqual(result.source_name, "Example News")
        self.assertEqual(result.publication_date, "2026-09-07")
        self.assertEqual(result.source_language, "English")
        self.assertEqual(result.category, "NATIONAL")

    def test_rejects_local_article_url(self):
        with self.assertRaises(ValueError):
            validate_public_url("https://127.0.0.1/private")

    def test_infers_supported_categories(self):
        self.assertEqual(infer_category("/business/economy/story"), "BUSINESS")
        self.assertEqual(infer_category("/sport/cricket/story"), "SPORTS")
        self.assertEqual(infer_category("/world/asia/story"), "INTERNATIONAL")
        self.assertEqual(infer_category("/news/environment/story"), "SCIENCE")
        self.assertEqual(infer_category("Crime and Justice"), "NATIONAL")

    def test_normalizes_daily_star_script_date(self):
        self.assertEqual(
            normalize_publication_date("Mon, 09/07/2026 - 09:45"),
            "2026-09-07",
        )

    def test_extracts_daily_star_script_date_and_category(self):
        body = (
            "Bangladesh Bank announced a policy update for depositors. "
            "Officials explained the implementation timeline and the relevant "
            "financial safeguards for customers across the country. "
            "The report described how participating banks would process valid "
            "requests under the newly announced policy."
        )
        html = f"""
        <html lang="en">
          <head>
            <meta property="og:title" content="Bank announces policy update">
            <meta property="og:site_name" content="The Daily Star">
            <script>
              gtag("event", "custom", {{"created":"Mon, 09\\/07\\/2026 - 09:45"}});
            </script>
          </head>
          <body>
            <div class="block-article-meta-block"><a href="/business">BUSINESS</a></div>
            <article><p>{body}</p></article>
          </body>
        </html>
        """

        result = extract_article_html(
            html,
            "https://www.thedailystar.net/business/news/policy-update-4266801",
        )

        self.assertEqual(result.publication_date, "2026-09-07")
        self.assertEqual(result.category, "BUSINESS")


class DiscoveryTests(unittest.TestCase):
    def setUp(self):
        self.source = SourceConfig(
            slug="example",
            name="Example News",
            home_url="https://example.com",
            allowed_hosts=("example.com",),
            article_patterns=(re.compile(r"-\d{6,}$"),),
            excluded_paths=("/opinion",),
            source_language="English",
        )

    def test_canonical_url_removes_query_and_fragment(self):
        self.assertEqual(
            canonical_url(
                "https://example.com",
                "/news/example-story-123456?source=home#content",
            ),
            "https://example.com/news/example-story-123456",
        )

    def test_article_allowlist_and_pattern(self):
        self.assertTrue(
            looks_like_article(
                self.source,
                "https://example.com/news/example-story-123456",
            )
        )
        self.assertFalse(
            looks_like_article(
                self.source,
                "https://attacker.example/news/example-story-123456",
            )
        )

    def test_expected_metadata_failure_is_candidate_rejection(self):
        self.assertTrue(
            is_candidate_rejection(
                "Error: Could not detect required metadata: --category."
            )
        )
        self.assertFalse(is_candidate_rejection("Gemini API request failed"))
        self.assertFalse(
            looks_like_article(
                self.source,
                "https://example.com/opinion/example-story-123456",
            )
        )


if __name__ == "__main__":
    unittest.main()
