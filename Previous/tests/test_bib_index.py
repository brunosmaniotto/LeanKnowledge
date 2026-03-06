import unittest
import json
import os
from pathlib import Path
from leanknowledge.bib_index import BibIndex, BibEntry

class TestBibIndex(unittest.TestCase):
    def setUp(self):
        self.test_bib_content = """
@Book{abramsky94,
  author = {Abramsky, S. and Gabbay, D. M.},
  title = {Handbook of logic},
  year = {1994},
  publisher = {Oxford}
}

@Article{rudin1987,
  author = {Rudin, Walter},
  title = {Real and complex analysis},
  year = {1987}
}
"""
        self.test_bib_path = Path("test_references.bib")
        with open(self.test_bib_path, "w", encoding="utf-8") as f:
            f.write(self.test_bib_content)
            
        self.cache_path = Path("bib_index.json")
        if self.cache_path.exists():
            os.remove(self.cache_path)

    def tearDown(self):
        if self.test_bib_path.exists():
            os.remove(self.test_bib_path)
        if self.cache_path.exists():
            os.remove(self.cache_path)

    def test_parsing(self):
        index = BibIndex(self.test_bib_path)
        self.assertEqual(len(index.entries), 2)
        
        e1 = index.search_by_key("abramsky94")
        self.assertIsNotNone(e1)
        self.assertEqual(e1.entry_type, "book")
        self.assertIn("Abramsky", e1.authors[0])
        self.assertEqual(e1.year, "1994")
        
        e2 = index.search_by_key("rudin1987")
        self.assertIsNotNone(e2)
        self.assertEqual(e2.title, "Real and complex analysis")

    def test_search_by_author(self):
        index = BibIndex(self.test_bib_path)
        results = index.search_by_author("Rudin")
        self.assertEqual(len(results), 1)
        self.assertEqual(results[0].key, "rudin1987")
        
        results = index.search_by_author("Gabbay")
        self.assertEqual(len(results), 1)
        self.assertEqual(results[0].key, "abramsky94")

    def test_search_by_title(self):
        index = BibIndex(self.test_bib_path)
        results = index.search_by_title("Handbook")
        self.assertEqual(len(results), 1)
        self.assertEqual(results[0].key, "abramsky94")

    def test_fuzzy_search(self):
        index = BibIndex(self.test_bib_path)
        results = index.search("logic")
        self.assertEqual(len(results), 1)
        self.assertEqual(results[0].key, "abramsky94")
        
        results = index.search("abramsky")
        self.assertEqual(len(results), 1)

    def test_missing_file(self):
        index = BibIndex(Path("non_existent.bib"))
        self.assertEqual(len(index.entries), 0)

    def test_caching(self):
        index = BibIndex(self.test_bib_path)
        self.assertTrue(self.cache_path.exists())
        
        # Load again, should load from cache
        index2 = BibIndex(self.test_bib_path)
        self.assertEqual(len(index2.entries), 2)

if __name__ == "__main__":
    unittest.main()
