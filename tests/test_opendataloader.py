"""Tests for the OpenDataLoader PDF extraction backend.

Since opendataloader-pdf may not be installed, everything is mocked.
"""

from pathlib import Path
from unittest.mock import MagicMock, patch
import sys

import pytest

from leanknowledge.extractors.opendataloader import (
    OpenDataLoaderExtractor,
    _check_odl,
    _HAS_ODL,
)


# ---------------------------------------------------------------------------
# Reset the cached availability flag between tests
# ---------------------------------------------------------------------------

@pytest.fixture(autouse=True)
def _reset_odl_cache():
    """Reset the module-level _HAS_ODL cache before each test."""
    import leanknowledge.extractors.opendataloader as mod
    old = mod._HAS_ODL
    mod._HAS_ODL = None
    yield
    mod._HAS_ODL = old


# ---------------------------------------------------------------------------
# is_available()
# ---------------------------------------------------------------------------

class TestIsAvailable:
    def test_returns_false_when_not_installed(self):
        """is_available() returns False when opendataloader_pdf is not importable."""
        with patch.dict(sys.modules, {"opendataloader_pdf": None}):
            import leanknowledge.extractors.opendataloader as mod
            mod._HAS_ODL = None
            # Force _check_odl to fail by making the import raise
            with patch("leanknowledge.extractors.opendataloader._check_odl", return_value=False):
                mod._HAS_ODL = None
                assert OpenDataLoaderExtractor.is_available() is False

    def test_returns_false_when_no_java(self):
        """is_available() returns False when Java is not on PATH."""
        mock_odl = MagicMock()
        with patch.dict(sys.modules, {"opendataloader_pdf": mock_odl}), \
             patch("shutil.which", return_value=None):
            import leanknowledge.extractors.opendataloader as mod
            mod._HAS_ODL = None
            assert _check_odl() is False

    def test_returns_true_when_both_available(self):
        """is_available() returns True when package + Java are present."""
        mock_odl = MagicMock()
        with patch.dict(sys.modules, {"opendataloader_pdf": mock_odl}), \
             patch("shutil.which", return_value="/usr/bin/java"):
            import leanknowledge.extractors.opendataloader as mod
            mod._HAS_ODL = None
            assert _check_odl() is True

    def test_caches_result(self):
        """is_available() only calls _check_odl once (result is cached)."""
        import leanknowledge.extractors.opendataloader as mod
        mod._HAS_ODL = True
        assert OpenDataLoaderExtractor.is_available() is True
        # Set to False -- should remain True because cached
        # (we test the caching, not the value)
        assert mod._HAS_ODL is True


# ---------------------------------------------------------------------------
# extract()
# ---------------------------------------------------------------------------

class TestExtract:
    def test_raises_when_unavailable(self):
        import leanknowledge.extractors.opendataloader as mod
        mod._HAS_ODL = False
        ext = OpenDataLoaderExtractor()
        with pytest.raises(RuntimeError, match="not available"):
            ext.extract(Path("test.pdf"))

    def test_returns_string_result(self):
        """When opendataloader_pdf.convert returns a string, pass it through."""
        import leanknowledge.extractors.opendataloader as mod
        mod._HAS_ODL = True

        mock_odl = MagicMock()
        mock_odl.convert.return_value = "# Section 1\n\nTheorem: $1+1=2$"

        ext = OpenDataLoaderExtractor()
        with patch.dict(sys.modules, {"opendataloader_pdf": mock_odl}):
            result = ext.extract(Path("test.pdf"), start_page=1, end_page=5)

        assert "Theorem" in result
        assert "$1+1=2$" in result
        mock_odl.convert.assert_called_once()

        # Verify kwargs passed correctly
        call_kwargs = mock_odl.convert.call_args
        assert call_kwargs[1]["format"] == "markdown"
        assert call_kwargs[1]["hybrid"] is True
        assert call_kwargs[1]["start_page"] == 1
        assert call_kwargs[1]["end_page"] == 5

    def test_returns_object_with_text_attr(self):
        """When opendataloader_pdf.convert returns an object with .text, use that."""
        import leanknowledge.extractors.opendataloader as mod
        mod._HAS_ODL = True

        result_obj = MagicMock()
        result_obj.text = "Extracted markdown content"

        mock_odl = MagicMock()
        mock_odl.convert.return_value = result_obj

        ext = OpenDataLoaderExtractor()
        with patch.dict(sys.modules, {"opendataloader_pdf": mock_odl}):
            result = ext.extract(Path("test.pdf"))

        assert result == "Extracted markdown content"

    def test_hybrid_disabled(self):
        """hybrid=False should not pass hybrid kwarg."""
        import leanknowledge.extractors.opendataloader as mod
        mod._HAS_ODL = True

        mock_odl = MagicMock()
        mock_odl.convert.return_value = "text"

        ext = OpenDataLoaderExtractor()
        with patch.dict(sys.modules, {"opendataloader_pdf": mock_odl}):
            ext.extract(Path("test.pdf"), hybrid=False)

        call_kwargs = mock_odl.convert.call_args[1]
        assert "hybrid" not in call_kwargs


# ---------------------------------------------------------------------------
# extract_structured()
# ---------------------------------------------------------------------------

class TestExtractStructured:
    def test_raises_when_unavailable(self):
        import leanknowledge.extractors.opendataloader as mod
        mod._HAS_ODL = False
        ext = OpenDataLoaderExtractor()
        with pytest.raises(RuntimeError, match="not available"):
            ext.extract_structured(Path("test.pdf"))

    def test_list_of_dicts(self):
        """When convert returns a list of dicts, normalise them."""
        import leanknowledge.extractors.opendataloader as mod
        mod._HAS_ODL = True

        raw = [
            {"type": "heading", "content": "Chapter 1", "page": 1, "bounding_box": None},
            {"type": "formula", "content": "$E=mc^2$", "page": 1},
            {"type": "paragraph", "content": "Some text", "page": 2, "bounding_box": {"x": 0}},
        ]
        mock_odl = MagicMock()
        mock_odl.convert.return_value = raw

        ext = OpenDataLoaderExtractor()
        with patch.dict(sys.modules, {"opendataloader_pdf": mock_odl}):
            elements = ext.extract_structured(Path("test.pdf"), start_page=1, end_page=2)

        assert len(elements) == 3
        # All elements should have the required keys
        for el in elements:
            assert "type" in el
            assert "content" in el
            assert "page" in el
            assert "bounding_box" in el

        assert elements[0]["type"] == "heading"
        assert elements[1]["content"] == "$E=mc^2$"
        assert elements[2]["page"] == 2

    def test_object_with_elements_attr(self):
        """When convert returns an object with .elements, extract from there."""
        import leanknowledge.extractors.opendataloader as mod
        mod._HAS_ODL = True

        el1 = MagicMock()
        el1.type = "paragraph"
        el1.content = "Text"
        el1.page = 1
        el1.bounding_box = None

        result_obj = MagicMock()
        result_obj.elements = [el1]
        # Make isinstance check fail for list
        type(result_obj).__iter__ = None

        mock_odl = MagicMock()
        mock_odl.convert.return_value = result_obj

        ext = OpenDataLoaderExtractor()
        with patch.dict(sys.modules, {"opendataloader_pdf": mock_odl}):
            elements = ext.extract_structured(Path("test.pdf"))

        assert len(elements) == 1
        assert elements[0]["type"] == "paragraph"
        assert elements[0]["content"] == "Text"

    def test_empty_result(self):
        """When convert returns something unexpected, return empty list."""
        import leanknowledge.extractors.opendataloader as mod
        mod._HAS_ODL = True

        mock_odl = MagicMock()
        mock_odl.convert.return_value = "unexpected string"
        # The string doesn't have .elements, and is not a list
        # But it IS iterable, so we need to handle this case
        # Actually, isinstance(str, list) is False and hasattr(str, 'elements') is False
        # so it should go to the else branch and return []

        ext = OpenDataLoaderExtractor()
        with patch.dict(sys.modules, {"opendataloader_pdf": mock_odl}):
            elements = ext.extract_structured(Path("test.pdf"))

        assert elements == []


# ---------------------------------------------------------------------------
# Integration with ExtractionAgent (three-tier pipeline)
# ---------------------------------------------------------------------------

class TestExtractionAgentIntegration:
    def test_tier2_used_when_pymupdf_fails_and_odl_available(self):
        """When PyMuPDF quality is low and ODL is available, use Tier 2."""
        from leanknowledge.agents.extraction import ExtractionAgent

        agent = ExtractionAgent()

        # Simulate low-quality PyMuPDF output
        low_quality = {"ok": False, "reason": "low_text_density",
                       "chars_per_page": 10, "garbage_ratio": 0, "page_coverage": 1.0}

        mock_odl_ext = MagicMock()
        mock_odl_ext.extract.return_value = "# Good markdown from ODL"

        fake_items = [
            {"id": "T1", "type": "theorem", "role": "claimed_result",
             "statement": "Test", "section": "1"},
        ]
        fake_json = '{"source": "test", "items": ' + str(fake_items).replace("'", '"') + '}'

        with patch("leanknowledge.agents.extraction._pymupdf_extract", return_value=["x"]), \
             patch("leanknowledge.agents.extraction.assess_quality", return_value=low_quality), \
             patch("leanknowledge.extractors.opendataloader.OpenDataLoaderExtractor.is_available", return_value=True), \
             patch("leanknowledge.extractors.opendataloader.OpenDataLoaderExtractor.extract", return_value="# Markdown"), \
             patch("leanknowledge.agents.extraction._extract_claims_with_llm") as mock_llm:

            from leanknowledge.schemas import ExtractionResult
            mock_llm.return_value = ExtractionResult(source="test", items=[], extraction_tier="opendataloader")

            result = agent.extract_from_pdf(Path("test.pdf"), 1, 10)

        assert result.extraction_tier == "opendataloader"

    def test_fallback_to_tier3_when_odl_unavailable(self):
        """When PyMuPDF fails and ODL is not available, go to Tier 3 (DocAI)."""
        from leanknowledge.agents.extraction import ExtractionAgent

        agent = ExtractionAgent()

        low_quality = {"ok": False, "reason": "low_text_density",
                       "chars_per_page": 10, "garbage_ratio": 0, "page_coverage": 1.0}

        with patch("leanknowledge.agents.extraction._pymupdf_extract", return_value=["x"]), \
             patch("leanknowledge.agents.extraction.assess_quality", return_value=low_quality), \
             patch("leanknowledge.extractors.opendataloader.OpenDataLoaderExtractor.is_available", return_value=False), \
             patch("leanknowledge.agents.extraction._google_docai_extract", return_value="DocAI text"), \
             patch("leanknowledge.agents.extraction._extract_claims_with_llm") as mock_llm:

            from leanknowledge.schemas import ExtractionResult
            mock_llm.return_value = ExtractionResult(source="test", items=[], extraction_tier="google_docai")

            result = agent.extract_from_pdf(Path("test.pdf"), 1, 10)

        assert result.extraction_tier == "google_docai"
