"""Agent 1: Extraction — reads PDFs and extracts mathematical claims.

Three-tier text extraction:
  Tier 1: PyMuPDF (free, fast, local) — works well on born-digital PDFs
  Tier 2: OpenDataLoader hybrid (local, LaTeX support) — complex PDFs with formulas
  Tier 3: Google Document AI (paid, robust) — handles scans, complex layouts, math

After text extraction (any tier), an LLM reads the text and produces
structured claim objects.
"""

import json
import os
from pathlib import Path

from ..schemas import ExtractionResult, ExtractedItem
from ..pdf_quality import assess_quality

PROMPT_PATH = Path(__file__).resolve().parents[3] / "prompts" / "extraction_agent.md"


# ---------------------------------------------------------------------------
# Tier 1: PyMuPDF
# ---------------------------------------------------------------------------

def _pymupdf_extract(
    pdf_path: Path, start_page: int, end_page: int, *, ocr: bool = False,
) -> list[str]:
    """Extract text per page using PyMuPDF. Returns list of strings, one per page.

    If ocr=True, uses Tesseract OCR for scanned pages (requires tesseract installed).
    """
    import pymupdf

    doc = pymupdf.open(str(pdf_path))
    pages = []
    for page_num in range(start_page - 1, min(end_page, len(doc))):
        page = doc[page_num]
        if ocr:
            tp = page.get_textpage_ocr(language="eng", dpi=300, full=True)
            pages.append(page.get_text(textpage=tp))
        else:
            pages.append(page.get_text())
    doc.close()
    return pages


# ---------------------------------------------------------------------------
# Tier 2: Google Document AI
# ---------------------------------------------------------------------------

def _google_docai_extract(pdf_path: Path, start_page: int, end_page: int) -> str:
    """Extract text using Google Document AI.

    Requires:
      - GOOGLE_CLOUD_PROJECT env var
      - GOOGLE_DOCAI_PROCESSOR_ID env var
      - google-cloud-documentai package installed
      - Application Default Credentials configured

    Sends the full PDF, then slices the response to the requested page range.
    """
    from google.cloud import documentai_v1 as documentai
    from google.api_core.client_options import ClientOptions

    project_id = os.environ["GOOGLE_CLOUD_PROJECT"]
    processor_id = os.environ["GOOGLE_DOCAI_PROCESSOR_ID"]
    location = os.environ.get("GOOGLE_DOCAI_LOCATION", "us")

    opts = ClientOptions(api_endpoint=f"{location}-documentai.googleapis.com")
    client = documentai.DocumentProcessorServiceClient(client_options=opts)

    processor_name = client.processor_path(project_id, location, processor_id)

    pdf_bytes = pdf_path.read_bytes()
    raw_document = documentai.RawDocument(content=pdf_bytes, mime_type="application/pdf")
    request = documentai.ProcessRequest(name=processor_name, raw_document=raw_document)

    result = client.process_document(request=request)
    document = result.document

    # Extract text for the requested page range
    page_texts = []
    for page in document.pages:
        page_num = page.page_number  # 1-indexed
        if start_page <= page_num <= end_page:
            # Collect all text segments for this page
            segments = []
            for block in page.blocks:
                for segment in block.layout.text_anchor.text_segments:
                    start_idx = int(segment.start_index) if segment.start_index else 0
                    end_idx = int(segment.end_index)
                    segments.append(document.text[start_idx:end_idx])
            page_texts.append("".join(segments))

    return "\n\n".join(f"--- Page {start_page + i} ---\n{text}"
                       for i, text in enumerate(page_texts))


# ---------------------------------------------------------------------------
# LLM claim extraction (runs on text from either tier)
# ---------------------------------------------------------------------------

def _extract_claims_with_llm(text: str, source_label: str) -> ExtractionResult:
    """Send extracted text to LLM to produce structured claims.

    Routes through llm.complete() so any backend works (API, cli/claude, cli/gemini).
    Falls back to Anthropic SDK if LK_EXTRACTION_MODEL has no prefix (legacy).
    """
    model = os.environ.get("LK_EXTRACTION_MODEL", "cli/claude")

    system_prompt = PROMPT_PATH.read_text(encoding="utf-8") if PROMPT_PATH.exists() else ""
    user_prompt = (
        f"Source: {source_label}\n\n"
        f"--- BEGIN TEXT ---\n{text}\n--- END TEXT ---\n\n"
        f"Extract all formal mathematical items from the text above.\n\n"
        f"Respond with ONLY valid JSON matching this structure:\n"
        f'{{"source": "...", "items": [...]}}\n'
        f"Each item must have: id, type, role, statement, proof (or null), "
        f"proof_sketch (or null), dependencies (list), section, labeled (bool), "
        f"context (or null), notation_in_scope (dict)."
    )

    # Route through unified LLM gateway if model has a known prefix
    if "/" in model:
        from ..llm import complete
        response_text = complete(model, user_prompt, system_prompt, max_tokens=8192)
    else:
        # Legacy: bare model name → Anthropic SDK direct
        import anthropic
        client = anthropic.Anthropic()
        response = client.messages.create(
            model=model,
            max_tokens=8192,
            system=system_prompt,
            messages=[{"role": "user", "content": user_prompt}],
        )
        response_text = response.content[0].text

    # Strip markdown code fences if present
    if response_text.strip().startswith("```"):
        lines = response_text.strip().split("\n")
        lines = [l for l in lines if not l.strip().startswith("```")]
        response_text = "\n".join(lines)

    data = json.loads(response_text)
    return _validate_result(data, source_label)


def _validate_result(data: dict, source_label: str) -> ExtractionResult:
    if isinstance(data, dict):
        if "items" not in data:
            data = {"source": source_label, "items": data if isinstance(data, list) else [data]}
        if "source" not in data:
            data["source"] = source_label
        return ExtractionResult.model_validate(data)
    return ExtractionResult(source=source_label, items=[])


# ---------------------------------------------------------------------------
# Main agent
# ---------------------------------------------------------------------------

class ExtractionAgent:
    """Agent 1: Extract mathematical claims from PDFs.

    Three-tier extraction pipeline:
      Tier 1 (PyMuPDF): fast, free, local. Quality-checked automatically.
      Tier 2 (OpenDataLoader): local, hybrid extraction with LaTeX support.
      Tier 3 (Google Document AI): robust cloud fallback for the hardest cases.

    If OpenDataLoader is not installed, Tier 2 is skipped and the pipeline
    falls back directly from Tier 1 to Tier 3 (the original two-tier behaviour).
    """

    def extract_from_pdf(
        self,
        pdf_path: Path,
        start_page: int,
        end_page: int,
        source_label: str = "",
        force_tier: int | None = None,
    ) -> ExtractionResult:
        """Extract mathematical claims from PDF pages.

        Args:
            pdf_path: path to PDF file
            start_page: first page (1-indexed)
            end_page: last page (inclusive)
            source_label: human-readable source name
            force_tier: skip quality check, use tier 1, 2, or 3 directly
        """
        if not source_label:
            source_label = f"{pdf_path.stem} pp.{start_page}-{end_page}"

        if force_tier == 2:
            return self._run_tier2(pdf_path, start_page, end_page, source_label)
        if force_tier == 3:
            return self._run_tier3(pdf_path, start_page, end_page, source_label)

        # Tier 1a: PyMuPDF (text extraction)
        pages = _pymupdf_extract(pdf_path, start_page, end_page)
        quality = assess_quality(pages)

        if quality["ok"]:
            print(f"  [Tier 1] PyMuPDF: quality OK "
                  f"(avg {quality['chars_per_page']:.0f} chars/page, "
                  f"coverage {quality['page_coverage']:.0%})")
            text = "\n\n".join(
                f"--- Page {start_page + i} ---\n{page}"
                for i, page in enumerate(pages)
            )
            result = _extract_claims_with_llm(text, source_label)
            result.extraction_tier = "pymupdf"
            return result

        # Tier 1b: PyMuPDF with OCR (scanned PDFs)
        print(f"  [Tier 1] PyMuPDF text: quality insufficient ({quality['reason']}). "
              f"Trying OCR...")
        try:
            pages = _pymupdf_extract(pdf_path, start_page, end_page, ocr=True)
            quality = assess_quality(pages)
            if quality["ok"]:
                print(f"  [Tier 1b] PyMuPDF OCR: quality OK "
                      f"(avg {quality['chars_per_page']:.0f} chars/page, "
                      f"coverage {quality['page_coverage']:.0%})")
                text = "\n\n".join(
                    f"--- Page {start_page + i} ---\n{page}"
                    for i, page in enumerate(pages)
                )
                result = _extract_claims_with_llm(text, source_label)
                result.extraction_tier = "pymupdf_ocr"
                return result
            print(f"  [Tier 1b] PyMuPDF OCR: still insufficient ({quality['reason']}).")
        except Exception as exc:
            print(f"  [Tier 1b] PyMuPDF OCR failed: {exc}")

        # Tier 2: OpenDataLoader if available
        from ..extractors.opendataloader import OpenDataLoaderExtractor

        if OpenDataLoaderExtractor.is_available():
            print(f"  Escalating to Tier 2 (OpenDataLoader).")
            return self._run_tier2(pdf_path, start_page, end_page, source_label)

        # Tier 3: Google Document AI
        print(f"  OpenDataLoader not available. "
              f"Escalating to Tier 3 (Google Document AI).")
        return self._run_tier3(pdf_path, start_page, end_page, source_label)

    def _run_tier2(
        self, pdf_path: Path, start_page: int, end_page: int, source_label: str
    ) -> ExtractionResult:
        """Run Tier 2 extraction via OpenDataLoader PDF."""
        from ..extractors.opendataloader import OpenDataLoaderExtractor

        print(f"  [Tier 2] OpenDataLoader: processing {source_label}")
        extractor = OpenDataLoaderExtractor()
        try:
            text = extractor.extract(
                pdf_path, start_page=start_page, end_page=end_page, hybrid=True,
            )
            result = _extract_claims_with_llm(text, source_label)
            result.extraction_tier = "opendataloader"
            return result
        except Exception as exc:
            print(f"  [Tier 2] OpenDataLoader failed: {exc}. "
                  f"Escalating to Tier 3 (Google Document AI).")
            return self._run_tier3(pdf_path, start_page, end_page, source_label)

    def _run_tier3(
        self, pdf_path: Path, start_page: int, end_page: int, source_label: str
    ) -> ExtractionResult:
        """Run Tier 3 extraction via Google Document AI."""
        print(f"  [Tier 3] Google Document AI: processing {source_label}")
        text = _google_docai_extract(pdf_path, start_page, end_page)
        result = _extract_claims_with_llm(text, source_label)
        result.extraction_tier = "google_docai"
        return result

    def extract_from_text(self, text: str, source_label: str = "") -> ExtractionResult:
        """Extract from raw text (for non-PDF sources like markdown or LaTeX)."""
        return _extract_claims_with_llm(text, source_label)
