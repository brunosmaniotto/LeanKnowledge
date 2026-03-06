"""PDF text quality assessment — decides whether PyMuPDF output is good enough
or needs escalation to Google Document AI.

Quality signals checked:
1. Text density: pages with very little text are likely scanned images
2. Unicode garbage: broken math symbols, replacement characters
3. Structural coherence: does the text look like readable prose/math?
"""

import re
import statistics

# Characters that indicate broken extraction (common PyMuPDF failures on math)
GARBAGE_PATTERN = re.compile(r"[\ufffd\ufffe\uffff]|[?\x00-\x08\x0e-\x1f]")

# Minimum average characters per page to consider extraction successful
MIN_CHARS_PER_PAGE = 100

# Maximum ratio of garbage characters to total characters
MAX_GARBAGE_RATIO = 0.03

# Minimum fraction of pages that must have extractable text
MIN_PAGE_COVERAGE = 0.7


def assess_quality(pages: list[str]) -> dict:
    """Assess the quality of PyMuPDF-extracted text.

    Args:
        pages: list of text strings, one per page.

    Returns:
        dict with keys:
            - ok: bool — True if quality is acceptable
            - reason: str | None — explanation if not ok
            - chars_per_page: float
            - garbage_ratio: float
            - page_coverage: float
    """
    if not pages:
        return {"ok": False, "reason": "no_pages", "chars_per_page": 0,
                "garbage_ratio": 0, "page_coverage": 0}

    page_lengths = [len(p.strip()) for p in pages]
    total_chars = sum(page_lengths)
    non_empty_pages = sum(1 for l in page_lengths if l > 20)

    chars_per_page = statistics.mean(page_lengths) if page_lengths else 0
    page_coverage = non_empty_pages / len(pages)

    # Count garbage characters
    all_text = "\n".join(pages)
    garbage_count = len(GARBAGE_PATTERN.findall(all_text))
    garbage_ratio = garbage_count / max(total_chars, 1)

    # Decision
    if page_coverage < MIN_PAGE_COVERAGE:
        return {"ok": False, "reason": "low_page_coverage",
                "chars_per_page": chars_per_page, "garbage_ratio": garbage_ratio,
                "page_coverage": page_coverage}

    if chars_per_page < MIN_CHARS_PER_PAGE:
        return {"ok": False, "reason": "low_text_density",
                "chars_per_page": chars_per_page, "garbage_ratio": garbage_ratio,
                "page_coverage": page_coverage}

    if garbage_ratio > MAX_GARBAGE_RATIO:
        return {"ok": False, "reason": "high_garbage_ratio",
                "chars_per_page": chars_per_page, "garbage_ratio": garbage_ratio,
                "page_coverage": page_coverage}

    return {"ok": True, "reason": None, "chars_per_page": chars_per_page,
            "garbage_ratio": garbage_ratio, "page_coverage": page_coverage}
