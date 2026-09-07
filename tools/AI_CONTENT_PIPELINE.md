# NewsLLM AI content pipeline

This tool downloads one public news article, extracts its metadata and body,
and converts it into validated English and Bangla study content, facts, key
terms, and MCQs. Preview mode does not change Firestore.

## 1. Install dependencies

Use the existing NewsLLM admin environment:

```bash
"$HOME/Downloads/newsllm-admin-env/bin/python" -m pip install \
  -r tools/requirements.txt
```

## 2. Configure secrets

Create a Gemini API key in Google AI Studio, then export both secrets in the
current terminal session:

```bash
export GEMINI_API_KEY='paste-your-gemini-api-key-here'
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/Downloads/newsllm-service-account.json"
```

Never paste either secret into a Dart or Python source file and never commit
the service-account JSON.

## 3. Generate a URL-only preview

For supported public pages, the normal workflow only needs the article URL:

```bash
"$HOME/Downloads/newsllm-admin-env/bin/python" \
  tools/generate_news_content.py \
  --article-url "https://example.com/original-article"
```

The tool attempts to detect the headline, publisher, publication date, source
language, category, and article body. It prints the detected metadata before
calling Gemini. Pass an explicit option when a field cannot be detected or
needs correction, for example:

```bash
"$HOME/Downloads/newsllm-admin-env/bin/python" \
  tools/generate_news_content.py \
  --article-url "https://example.com/original-article" \
  --category NATIONAL \
  --publication-date 2026-09-07
```

## 4. Manual file fallback

Some sites block automated downloads, require JavaScript, or place content
behind a paywall. In that case, save the article body as
`~/Downloads/news_article.txt` and run:

```bash
"$HOME/Downloads/newsllm-admin-env/bin/python" \
  tools/generate_news_content.py \
  --article-file "$HOME/Downloads/news_article.txt" \
  --headline "Original article headline" \
  --source-name "The Daily Star" \
  --source-url "https://example.com/original-article" \
  --category NATIONAL \
  --source-language English \
  --publication-date 2026-09-07
```

Use only sources and content you are authorised to process. Never bypass a
publisher login or paywall.

## 5. Review the preview

Check that names, dates, numbers, summaries, translations, correct answers,
and explanations are supported by the original article.

## 6. Publish the reviewed result

Repeat the preview command and add `--publish` at the end. The generated JSON
is shown and the tool requires you to type `PUBLISH` before writing that exact
result. The script refuses to overwrite an existing document unless `--force`
is explicitly supplied.

The `--yes` option skips the confirmation and is reserved for a reviewed,
trusted scheduled job. Do not use it while testing a new source.

After publishing, restart Flutter so its startup query reloads Firestore:

```bash
flutter run -d chrome
```

In SQL terms, the Pydantic models act like column constraints, the generated
document is the validated row, and the final Firestore batch is the `INSERT`.

This is a daily batch/admin workflow, not live news streaming. The local file
option remains available as a reliable fallback when URL extraction fails.
