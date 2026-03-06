"""Tests for the PDF quality gate (Tier 1 → Tier 2 escalation decision)."""

from leanknowledge.pdf_quality import assess_quality


def test_good_quality_passes():
    pages = [
        "This is a well-extracted page with plenty of text. " * 10,
        "Another page with mathematical content: Let f: R → R be continuous. " * 8,
        "Theorem 3.1. If X is compact and f is continuous, then f(X) is compact. " * 6,
    ]
    result = assess_quality(pages)
    assert result["ok"] is True
    assert result["reason"] is None


def test_empty_pages_fail():
    result = assess_quality([])
    assert result["ok"] is False
    assert result["reason"] == "no_pages"


def test_scanned_pdf_low_coverage():
    """Simulates a scanned PDF where most pages have no extractable text."""
    pages = ["", "", "", "Some OCR artifact", "", "", "", "", "", ""]
    result = assess_quality(pages)
    assert result["ok"] is False
    assert result["reason"] == "low_page_coverage"


def test_low_density_fails():
    """Pages with very little text per page."""
    pages = ["x", "y", "z", "w", "v"]
    result = assess_quality(pages)
    assert result["ok"] is False
    # Either low_page_coverage or low_text_density


def test_garbage_characters_fail():
    """Unicode replacement characters indicate broken extraction."""
    clean_text = "Normal mathematical text about topology. " * 20
    garbage = "\ufffd" * 50  # lots of replacement characters
    pages = [clean_text + garbage] * 3
    result = assess_quality(pages)
    assert result["ok"] is False
    assert result["reason"] == "high_garbage_ratio"


def test_mixed_quality_passes_if_enough_coverage():
    """A few blank pages are OK if most pages have text."""
    good_page = "Proof. By the intermediate value theorem, there exists c in (a,b). " * 10
    pages = [good_page] * 8 + ["", ""]  # 80% coverage
    result = assess_quality(pages)
    assert result["ok"] is True
