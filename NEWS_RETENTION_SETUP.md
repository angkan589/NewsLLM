# News retention update

## Behavior

- More from today: newest six articles dated today in Bangladesh (UTC+6).
- The existing top button and a new bottom View all news button open the last
  seven days. If fewer than six exist, show only those; no older filler.
- The lead story and homepage fact preview also use today's selection.
- General news, categories, source pages, search and quiz article pools use the
  same seven-day repository. Empty production feeds no longer show demo news.
- New bookmarks contain the full bilingual article and quiz in the user's
  private Firestore bookmark document. They remain available after expiry.
- Retention is based on publishedAt, not bookmark date: 168 hours. The UI
  refreshes each minute; physical deletion runs hourly (GitHub scheduling may
  be delayed). Bookmarks are never removed by cleanup.
- The cleanup migrates existing title-only bookmarks before any deletion.
  Ambiguous title matches stop the run rather than guessing. Sources already
  deleted before this update cannot be reconstructed.
- Firestore rules require snapshots for bookmark writes so older app versions
  cannot add title-only bookmarks during/after cleanup.

## Apply on your Mac

Run in your NewsLLM repository. Keep any local work committed or stashed first.
The patch was built against main commit dc49f2fadbe4907b887f077b8d8fc7068c79c8bd.
Do not force it if the check fails; the repository may have changed.

```bash
git apply --check ~/Downloads/newsllm-retention.patch
git apply ~/Downloads/newsllm-retention.patch
flutter pub get
flutter analyze
flutter test
python3 -m unittest discover -s tools -p 'test_cleanup_news.py'
flutter build web --release
```

Review `git diff`. Commit these changes and push your branch/main using your
normal workflow. Main's Flutter Web CI and Deploy now deploys Firestore rules,
indexes, and hosting together after the tests pass. The existing service
account needs permission to deploy Firestore rules/indexes as well as hosting.

## Activate cleanup AFTER a successful deployment

1. Refresh the live app. Check the home feed and both View all news buttons.
2. Bookmark an article and confirm its bookmark document contains
   `articleSnapshot`. Open Saved briefings to confirm it is readable.
3. GitHub > Actions > News retention cleanup > Run workflow. Leave apply OFF
   for a preview. Check the counts and any warnings in its logs.
4. Run again with apply ON. This migrates old bookmarks before deletion.
5. GitHub > Settings > Secrets and variables > Actions > Variables:
   add `ENABLE_NEWS_CLEANUP` = `true` to enable hourly runs.

The job reuses `FIREBASE_SERVICE_ACCOUNT_B64`; no new secret is needed.
It is independent of Gemini and the daily content generation workflow, so
cleanup can run even if generation is disabled or fails. Do not configure
Firestore TTL on articles: direct TTL deletion would bypass legacy migration.

## Validation performed while preparing this patch

Python retention tests and git diff/patch checks were run. Flutter/Dart are
not installed in the preparation environment; run the Flutter commands above
and require the deployment workflow to pass. No live database was changed.
