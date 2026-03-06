"""Agent 1: Extraction — reads PDFs and extracts mathematical claims.

Two-tier text extraction:
  Tier 1: PyMuPDF (free, fast, local) — works well on born-digital PDFs
  Tier 2: Google Document AI (paid, robust) — handles scans, complex layouts, math

After text extraction (either tier), an LLM reads the text and produces
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

def _pymupdf_extract(pdf_path: Path, start_page: int, end_page: int) -> list[str]:
    """Extract text per page using PyMuPDF. Returns list of strings, one per page."""
    import pymupdf

    doc = pymupdf.open(str(pdf_path))
    pages = []
    for page_num in range(start_page - 1, min(end_page, len(doc))):
        page = doc[page_num]
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

    Uses the Anthropic SDK directly (not Claude Code CLI).
    """
    import anthropic

    system_prompt = PROMPT_PATH.read_text() if PROMPT_PATH.exists() else ""
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

    client = anthropic.Anthropic()
    response = client.messages.create(
        model=os.environ.get("LK_EXTRACTION_MODEL", "claude-sonnet-4-20250514"),
        max_tokens=8192,
        system=system_prompt,
        messages=[{"role": "user", "content": user_prompt}],
    )

    # Parse response
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

    Tier 1 (PyMuPDF): fast, free, local. Quality-checked automatically.
    Tier 2 (Google Document AI): robust, handles scans and complex layouts.
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
            force_tier: skip quality check, use tier 1 or 2 directly
        """
        if not source_label:
            source_label = f"{pdf_path.stem} pp.{start_page}-{end_page}"

        if force_tier == 2:
            return self._run_tier2(pdf_path, start_page, end_page, source_label)

        # Tier 1: PyMuPDF
        pages = _pymupdf_extract(pdf_path, start_page, end_page)
        quality = assess_quality(pages)

        if quality["ok"] and force_tier != 2:
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

        # Escalate to Tier 2
        print(f"  [Tier 1] PyMuPDF: quality insufficient ({quality['reason']}). "
              f"Escalating to Tier 2 (Google Document AI).")
        return self._run_tier2(pdf_path, start_page, end_page, source_label)

    def _run_tier2(
        self, pdf_path: Path, start_page: int, end_page: int, source_label: str
    ) -> ExtractionResult:
        """Run Tier 2 extraction via Google Document AI."""
        print(f"  [Tier 2] Google Document AI: processing {source_label}")
        text = _google_docai_extract(pdf_path, start_page, end_page)
        result = _extract_claims_with_llm(text, source_label)
        result.extraction_tier = "google_docai"
        return result

    def extract_from_text(self, text: str, source_label: str = "") -> ExtractionResult:
        """Extract from raw text (for non-PDF sources like markdown or LaTeX)."""
        return _extract_claims_with_llm(text, source_label)
