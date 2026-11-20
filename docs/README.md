@'

\# NewsLLM Architecture Overview



\## 1. Project Overview



NewsLLM is a bilingual, exam-focused news briefing and quiz application built with Flutter.



The project uses a feature-oriented folder structure to organize application functionality.



\## 2. Core Structure



The core directory contains shared application components:



\- Navigation

\- Theme management

\- Localization

\- Session management



\## 3. Feature Modules



The features directory separates application functionality into:



\- Authentication

\- Home and news briefings

\- News repositories

\- Bookmarks

\- Search

\- Quiz

\- Progress tracking

\- Profile

\- Settings

\- Fact bank

\- Landing page



\## 4. News Data Organization



The news feature contains:



\- mock\_news\_repository.dart

\- firestore\_news\_repository.dart

\- news\_article.dart



These files separate mock data, Firestore-backed data and article models.



\## 5. Firebase Integration



The project declares Firebase Core, Firebase Authentication and Cloud Firestore dependencies.



Firebase platform configuration is maintained in firebase\_options.dart.



\## 6. Testing



Existing tests are maintained in the test directory.



\## 7. Automated Workflows



The GitHub Actions workflow directory contains:



\- daily-news.yml

\- cleanup-news.yml

\- flutter-web.yml



\## 8. Development Principles



\- Keep feature-related code organized.

\- Reuse shared components.

\- Separate data models from presentation.

\- Avoid unnecessary Firebase configuration changes.

\- Preserve existing functionality when extending the application.

'@ | Set-Content -Path docs/ARCHITECTURE.md -Encoding utf8

