# NewsLLM Architecture Overview

## 1. Project Overview

NewsLLM is a bilingual, exam-focused news briefing and quiz application built with Flutter.

The project uses a feature-oriented folder structure to organize application functionality.

## 2. Core Structure

### Core
The core directory contains shared application components.

- navigation: Main application navigation.
- theme: Application themes, colors and theme extensions.
- localization: Reusable localized text components.
- session: Application session management.

### Features

The features directory separates functionality into independent areas:

- auth: Authentication interface.
- home: Homepage, category news and article details.
- news: News data sources and article models.
- bookmarks: Saved news articles.
- search: News search functionality.
- quiz: Quiz functionality and related models.
- progress: Examination history and progress.
- profile: User profile.
- settings: Application settings.
- fact_bank: Fact bank functionality.
- landing: Landing page and presentation components.

## 3. News Data Organization

The news feature contains:

- mock_news_repository.dart
- firestore_news_repository.dart
- news_article.dart

These files provide separate locations for mock data, Firestore-backed news data and the news article model.

## 4. Firebase Integration

The project declares the following Firebase dependencies:

- Firebase Core
- Firebase Authentication
- Cloud Firestore

Firebase platform configuration is maintained in firebase_options.dart.

## 5. Testing

The existing test directory contains:

- widget_test.dart
- news_retention_test.dart

## 6. Automated Workflows

The GitHub Actions workflow directory contains:

- daily-news.yml
- cleanup-news.yml
- flutter-web.yml

These workflows support scheduled news processing, cleanup and Flutter web automation.

## 7. Development Principles

- Keep feature-related code organized within its feature directory.
- Reuse shared components from the core directory.
- Keep data models separate from presentation widgets.
- Avoid unnecessary changes to Firebase configuration.
- Preserve existing application behavior when extending functionality.
