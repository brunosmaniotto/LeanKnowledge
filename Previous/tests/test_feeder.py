import unittest
from unittest.mock import MagicMock, patch
from pathlib import Path
from leanknowledge.agents.feeder import FeederAgent, FeederResult
from leanknowledge.schemas import BacklogEntry, ExtractedItem, StatementType, ClaimRole, Domain, BacklogStatus

class TestFeederAgent(unittest.TestCase):
    def setUp(self):
        self.sources_dir = Path("Sources")
        self.mock_call = MagicMock()
        self.agent = FeederAgent(sources_dir=self.sources_dir, call_fn=self.mock_call)
        
        # Mock available sources
        self.agent._sources_cache = ["test_book.pdf", "rudin.pdf"]

    def test_search_referenced_found(self):
        # Setup mock response
        self.mock_call.return_value = {
            "found": True,
            "source_file": "test_book.pdf",
            "location": "10-12",
            "reasoning": "Found it"
        }
        
        # Create dummy entry
        item = ExtractedItem(
            id="Test.1",
            type=StatementType.THEOREM,
            statement="Test theorem",
            section="1"
        )
        entry = BacklogEntry(
            item=item,
            source="Test",
            domain=Domain.REAL_ANALYSIS,
            category="referenced"
        )
        
        # Test
        with patch.object(Path, 'exists') as mock_exists:
            mock_exists.return_value = True
            result = self.agent.find_source(entry)
            
            self.assertTrue(result.found)
            self.assertEqual(result.source_path, self.sources_dir / "test_book.pdf")
            self.assertEqual(result.page_range, (10, 12))

    def test_search_not_found(self):
        self.mock_call.return_value = {
            "found": False,
            "reasoning": "Not found"
        }
        
        item = ExtractedItem(id="Test.2", type=StatementType.THEOREM, statement="Missing", section="1")
        entry = BacklogEntry(item=item, source="Test", domain=Domain.ALGEBRA, category="unreferenced")
        
        result = self.agent.find_source(entry)
        self.assertFalse(result.found)

if __name__ == "__main__":
    unittest.main()
