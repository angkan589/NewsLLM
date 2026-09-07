# NewsLLM

NewsLLM is a bilingual Flutter web app that turns current newspaper coverage
into concise, exam-focused briefings in English and Bangla. It includes quick
facts, article quizzes, saved stories, search, progress tracking and Firebase
authentication.

## Content pipeline

The scheduled GitHub Actions pipeline discovers articles from configured,
accessible newspaper sources, extracts the original article, generates
bilingual study material with Gemini and publishes validated results to
Firestore. Sources that block automated access stay disabled.

The schedule runs daily at 06:15 Bangladesh time. Manual preview and publish
runs are also available from the **Daily NewsLLM Content** workflow.

## Local development

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

Firebase configuration is generated in `lib/firebase_options.dart`. Never
commit API keys or service-account private keys.

## Production

Pushes to `main` run Flutter analysis, tests and a release web build. When all
checks pass, the workflow deploys `build/web` to Firebase Hosting.
