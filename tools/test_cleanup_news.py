import unittest
import sys
from unittest.mock import patch
from datetime import datetime, timedelta, timezone
from types import SimpleNamespace
from cleanup_news import cleanup, expired


class Doc:
    def __init__(self, id, data, path=None):
        self.id, self.data = id, data
        self.reference = SimpleNamespace(path=path or f'articles/{id}')

    def to_dict(self):
        return self.data


class DB:
    def __init__(self, articles, bookmarks):
        self.articles, self.bookmarks = articles, bookmarks

    def collection(self, name):
        return SimpleNamespace(stream=lambda: iter(self.articles))

    def collection_group(self, name):
        return SimpleNamespace(stream=lambda: iter(self.bookmarks))


class RetentionTests(unittest.TestCase):
    now = datetime(2026, 10, 27, 12, tzinfo=timezone.utc)

    def test_exact_boundary(self):
        cutoff = self.now - timedelta(days=7)
        self.assertTrue(expired({'publishedAt': cutoff}, self.now))
        self.assertFalse(expired({'publishedAt': cutoff + timedelta(seconds=1)}, self.now))
        self.assertFalse(expired({}, self.now))

    def test_legacy_bangla_bookmark_is_preserved(self):
        article = Doc('a', {'publishedAt': self.now - timedelta(days=8),
                           'localizedContent': {'en': {'title': 'News'},
                                                'bn': {'title': 'সংবাদ'}}})
        bookmark = Doc('b', {'articleTitle': 'সংবাদ'}, 'users/u/bookmarks/b')
        self.assertEqual(cleanup(DB([article], [bookmark]), now=self.now), (1, 1))

    def test_ambiguous_title_aborts(self):
        data = {'localizedContent': {'en': {'title': 'News'}}}
        bookmark = Doc('b', {'articleTitle': 'News'}, 'users/u/bookmarks/b')
        with self.assertRaises(RuntimeError):
            cleanup(DB([Doc('a', data), Doc('b', data)], [bookmark]), now=self.now)

    def test_existing_snapshot_survives_missing_source(self):
        bookmark = Doc('b', {'articleSnapshot': {'id': 'a', 'data': {}}},
                       'users/u/bookmarks/b')
        self.assertEqual(cleanup(DB([], [bookmark]), now=self.now), (0, 0))


class MigrationWriteTests(unittest.TestCase):
    def test_preservation_commits_before_delete_and_failure_stops_delete(self):
        now = RetentionTests.now
        for fail in [False, True]:
            events = []
            article = Doc('a', {'publishedAt': now - timedelta(days=8),
                               'localizedContent': {'en': {'title': 'News'}}})
            bookmark = Doc('b', {'articleTitle': 'News'}, 'users/u/bookmarks/b')
            for doc in [article, bookmark]:
                doc.exists = True
                doc.reference.get = lambda transaction, doc=doc: doc
            class Transaction:
                def update(self, ref, data):
                    if fail:
                        raise RuntimeError('Archive write failed')
                    events.append(('archive', data['articleSnapshot']['id']))
                def delete(self, ref):
                    events.append(('delete', ref.path))
            db = DB([article], [bookmark])
            db.transaction = Transaction
            firestore = SimpleNamespace(transactional=lambda fn: fn)
            with patch.dict(sys.modules, {
                'google.cloud': SimpleNamespace(firestore=firestore),
                'google.cloud.firestore': firestore,
            }):
                if fail:
                    with self.assertRaises(RuntimeError):
                        cleanup(db, apply=True, now=now)
                    self.assertEqual(events, [])
                else:
                    cleanup(db, apply=True, now=now)
                    self.assertEqual(events, [('archive', 'a'), ('delete', 'articles/a')])


if __name__ == '__main__':
    unittest.main()
