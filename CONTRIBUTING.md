# Contributing to NewsLLM

## Development Workflow

1. Fork or clone the repository.
2. Create a separate feature branch.
3. Keep changes focused and small.
4. Follow the existing project structure.
5. Review changes before committing.
6. Submit a pull request for review.

## Code Quality

Contributors should follow the existing Dart and Flutter coding conventions.

Before submitting changes, the recommended checks are:

- flutter pub get
- flutter analyze
- flutter test

## Testing

New functionality should include appropriate unit or widget tests.

Existing tests should be preserved unless there is a clear reason to update them.

## Security

- Never commit API keys or private credentials.
- Do not expose Firebase service-account credentials.
- Avoid unnecessary changes to Firebase security rules.

## Pull Requests

Pull requests should include:

- A clear description of the changes.
- The reason for the changes.
- Relevant testing information.
- Any known limitations.
