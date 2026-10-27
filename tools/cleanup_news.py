#!/usr/bin/env python3
"""Archive legacy bookmarks before removing articles older than 168 hours.

Dry-run by default. Uses the same service-account secret as the news pipeline.
Never deletes bookmarks. A failed/ambiguous migration aborts before deletion.
"""
import argparse
from datetime import datetime, timedelta, timezone


def article_titles(data):
    return {content.get('title', '').strip()
            for content in data.get('localizedContent', {}).values()
            if isinstance(content, dict) and content.get('title')}


def expired(data, now):
    published = data.get('publishedAt')
    return (isinstance(published, datetime) and published.tzinfo is not None
            and published <= now - timedelta(days=7))


def cleanup(database, *, apply=False, now=None):
    now = now or datetime.now(timezone.utc)
    articles = list(database.collection('articles').stream())
    by_id = {doc.id: doc for doc in articles}
    by_title = {}
    for doc in articles:
        for title in article_titles(doc.to_dict()):
            by_title.setdefault(title, []).append(doc)

    migrations = []
    for bookmark in database.collection_group('bookmarks').stream():
        # Only this app's users/{uid}/bookmarks/{id} records.
        parts = bookmark.reference.path.split('/')
        if len(parts) != 4 or parts[0] != 'users':
            continue
        data = bookmark.to_dict()
        snapshot = data.get('articleSnapshot')
        if (isinstance(snapshot, dict) and isinstance(snapshot.get('id'), str)
                and isinstance(snapshot.get('data'), dict)):
            continue
        source_id = data.get('sourceArticleId')
        matches = ([by_id[source_id]] if source_id in by_id else
                   by_title.get(data.get('articleTitle', '').strip(), []))
        if len(matches) > 1:
            raise RuntimeError(f'Ambiguous legacy bookmark {bookmark.reference.path}; '
                               'no articles deleted. Resolve sourceArticleId first.')
        if not matches:
            # Already missing source: cannot reconstruct it; do not pretend otherwise.
            print(f'WARNING: source already missing for {bookmark.reference.path}')
            continue
        source = matches[0]
        migrations.append((bookmark, source))

    print(f'Legacy bookmarks to preserve: {len(migrations)}')
    if apply:
        from google.cloud import firestore

        @firestore.transactional
        def preserve(transaction, reference, source):
            current = reference.get(transaction=transaction)
            if not current.exists:  # User removed it while this job ran.
                return
            if current.to_dict().get('articleSnapshot'):
                return
            transaction.update(reference, {
                'sourceArticleId': source.id,
                'articleSnapshot': {'id': source.id, 'data': source.to_dict()},
            })

        for bookmark, source in migrations:
            preserve(database.transaction(), bookmark.reference, source)

    stale = [doc for doc in articles if expired(doc.to_dict(), now)]
    print(f'Expired articles: {len(stale)}; apply={apply}')
    if apply:
        from google.cloud import firestore

        @firestore.transactional
        def remove_if_expired(transaction, reference):
            current = reference.get(transaction=transaction)
            if current.exists and expired(current.to_dict(), now):
                transaction.delete(reference)

        # All migrations have succeeded before the first deletion.
        for doc in stale:
            remove_if_expired(database.transaction(), doc.reference)
    return len(migrations), len(stale)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apply', action='store_true')
    parser.add_argument('--project-id', default='newsllm-21fad')
    args = parser.parse_args()
    import firebase_admin
    from firebase_admin import firestore
    firebase_admin.initialize_app(options={'projectId': args.project_id})
    cleanup(firestore.client(), apply=args.apply)


if __name__ == '__main__':
    main()
