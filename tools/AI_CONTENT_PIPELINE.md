# NewsLLM AI content pipeline

This tool converts one source article into validated English and Bangla study
content, facts, key terms, and MCQs. Preview mode does not change Firestore.

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

## 3. Prepare an article

Save the original news article text as:

```text
~/Downloads/news_article.txt
```

The file must contain the article body, not only its headline.

## 4. Generate a safe preview

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

Check that names, dates, numbers, summaries, translations, correct answers,
and explanations are supported by the original article.

## 5. Publish the reviewed result

Repeat the preview command and add `--publish` at the end. The script refuses
to overwrite an existing document unless `--force` is explicitly supplied.

After publishing, restart Flutter so its startup query reloads Firestore:

```bash
flutter run -d chrome
```

In SQL terms, the Pydantic models act like column constraints, the generated
document is the validated row, and the final Firestore batch is the `INSERT`.
