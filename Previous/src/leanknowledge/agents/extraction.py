"""Stage 0: Extraction Agent — reads PDFs/text and extracts mathematical items.

Handles both text-based and scanned PDFs. Processing priority:
1. MinerU (magic-pdf) — best quality, preserves LaTeX equations
2. PyMuPDF text extraction — fast fallback for digital PDFs
3. Image-based vision extraction — last resort for scanned PDFs
"""

import base64
import json
import subprocess
import tempfile
from pathlib import Path

from ..schemas import ExtractionResult
from ..claude_client import call_claude, _extract_json

PROMPT_PATH = Path(__file__).resolve().parents[3] / "prompts" / "extraction_agent.md"


def _mineru_available() -> bool:
    """Check if MinerU (magic-pdf) is installed."""
    try:
        import magic_pdf  # noqa: F401
        return True
    except ImportError:
        return False


def _mineru_convert(pdf_path: Path, start_page: int, end_page: int) -> str | None:
    """Convert PDF pages to clean Markdown with LaTeX using MinerU.

    Returns clean markdown text, or None if MinerU is unavailable or fails.
    Pages are 1-indexed (start_page=1 means the first page).
    """
    if not _mineru_available():
        return None

    try:
        from magic_pdf.data.data_reader_writer import FileBasedDataReader
        from magic_pdf.data.dataset import PymuDocDataset
        from magic_pdf.model.doc_analyze_by_custom_model import doc_analyze

        # Read the PDF
        reader = FileBasedDataReader("")
        pdf_bytes = reader.read(str(pdf_path))

        # Create dataset and run analysis
        ds = PymuDocDataset(pdf_bytes)

        # Run inference (auto-detect text vs OCR)
        infer_result = ds.apply(doc_analyze, ocr=True)

        # Extract markdown for the page range
        pipe_result = infer_result.pipe_ocr_mode(image_writer=None)

        md_content = pipe_result.get_markdown(
            start_page_id=start_page - 1,  # 0-indexed internally
            end_page_id=end_page - 1,
        )

        if md_content and md_content.strip():
            return md_content

    except Exception as e:
        print(f"  [extraction] MinerU conversion failed: {e}")

    return None


def _read_pdf_text(pdf_path: Path, start_page: int, end_page: int) -> str | None:
    """Try to extract text from PDF pages. Returns None if pages are scanned images."""
    import pymupdf

    doc = pymupdf.open(str(pdf_path))
    text_parts = []
    has_text = False

    for page_num in range(start_page - 1, min(end_page, len(doc))):
        page = doc[page_num]
        text = page.get_text().strip()
        if text:
            has_text = True
        text_parts.append(f"--- Page {page_num + 1} ---\n{text}")

    doc.close()

    if not has_text:
        return None  # Scanned PDF
    return "\n\n".join(text_parts)


def _pdf_pages_to_images(pdf_path: Path, start_page: int, end_page: int, dpi: int = 200) -> list[Path]:
    """Convert PDF pages to PNG images. Returns list of temp file paths."""
    import pymupdf

    doc = pymupdf.open(str(pdf_path))
    image_paths = []

    for page_num in range(start_page - 1, min(end_page, len(doc))):
        page = doc[page_num]
        # Render at higher DPI for readability
        mat = pymupdf.Matrix(dpi / 72, dpi / 72)
        pix = page.get_pixmap(matrix=mat)
        tmp = tempfile.NamedTemporaryFile(suffix=f"_p{page_num + 1}.png", delete=False)
        pix.save(tmp.name)
        image_paths.append(Path(tmp.name))

    doc.close()
    return image_paths


def _call_claude_with_images(image_paths: list[Path], prompt: str, system: str, schema) -> dict:
    """Call Claude Code CLI with images for vision-based extraction.

    Uses claude CLI with --allowedTools Read so Claude can read the image files.
    """
    import os

    # Build a prompt instructing Claude to read each image file
    read_instructions = "\n".join(
        f"- Read the image file at: {p}" for p in image_paths
    )

    full_prompt = (
        f"{system}\n\n{prompt}\n\n"
        f"IMPORTANT: First, read each of the following image files using the Read tool. "
        f"These are scanned textbook pages rendered as PNG images:\n{read_instructions}\n\n"
        f"After reading all the images, extract the mathematical items."
    )

    if schema:
        schema_json = json.dumps(schema.model_json_schema(), indent=2)
        full_prompt += (
            f"\n\nRespond with ONLY valid JSON conforming to this schema (no markdown, no explanation):\n"
            f"```json\n{schema_json}\n```"
        )

    cmd = [
        "claude", "-p", full_prompt,
        "--output-format", "json",
        "--allowedTools", "Read",
        "--permission-mode", "bypassPermissions",
    ]

    env = {k: v for k, v in os.environ.items() if k != "CLAUDECODE"}
    # Longer timeout: Claude needs to read multiple images + extract items
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=600, env=env)

    if result.returncode != 0:
        raise RuntimeError(f"Claude Code CLI failed: {result.stderr}")

    envelope = json.loads(result.stdout)
    text = envelope.get("result", result.stdout)
    return _extract_json(text)


class ExtractionAgent:
    def extract_from_pdf(
        self,
        pdf_path: Path,
        start_page: int,
        end_page: int,
        source_label: str = "",
    ) -> ExtractionResult:
        """Extract mathematical items from a range of PDF pages.

        Processing priority:
        1. MinerU → clean Markdown with LaTeX (best quality, ~80% token reduction)
        2. PyMuPDF text → raw text extraction (fast fallback)
        3. Image-based → vision extraction (scanned PDFs only)
        """
        if not source_label:
            source_label = f"{pdf_path.stem} pp.{start_page}-{end_page}"

        # Priority 1: Try MinerU for highest quality extraction
        mineru_text = _mineru_convert(pdf_path, start_page, end_page)
        if mineru_text:
            print("  (Using MinerU for high-quality Markdown+LaTeX extraction)")
            return self._extract_from_text_content(mineru_text, source_label)

        # Priority 2: Try PyMuPDF text extraction
        text = _read_pdf_text(pdf_path, start_page, end_page)

        if text is not None:
            return self._extract_from_text_content(text, source_label)
        else:
            # Priority 3: Image-based extraction for scanned PDFs
            print("  (Scanned PDF detected — using image-based extraction)")
            return self._extract_from_images(pdf_path, start_page, end_page, source_label)

    def _extract_from_text_content(self, text: str, source_label: str) -> ExtractionResult:
        """Extract from text content (text-based PDFs or raw text)."""
        system = PROMPT_PATH.read_text()
        prompt = (
            f"Source: {source_label}\n\n"
            f"--- BEGIN TEXT ---\n{text}\n--- END TEXT ---\n\n"
            f"Extract all formal mathematical items from the text above."
        )

        data = call_claude(prompt, system=system, schema=ExtractionResult, caller="extraction.extract")
        return self._validate_result(data, source_label)

    def _extract_from_images(
        self, pdf_path: Path, start_page: int, end_page: int, source_label: str,
        chunk_size: int = 3,
    ) -> ExtractionResult:
        """Extract from scanned PDF by converting pages to images.

        Processes pages in chunks to avoid Claude CLI timeout (each chunk <= chunk_size pages).
        """
        all_items = []
        system = PROMPT_PATH.read_text()

        for chunk_start in range(start_page, end_page + 1, chunk_size):
            chunk_end = min(chunk_start + chunk_size - 1, end_page)
            print(f"    Chunk: pages {chunk_start}-{chunk_end}")

            image_paths = _pdf_pages_to_images(pdf_path, chunk_start, chunk_end)
            try:
                prompt = (
                    f"Source: {source_label}\n"
                    f"Pages {chunk_start}-{chunk_end}\n\n"
                    f"Read the textbook pages in the images and extract all mathematical items."
                )
                data = _call_claude_with_images(image_paths, prompt, system, ExtractionResult)
                chunk_result = self._validate_result(data, source_label)
                all_items.extend(chunk_result.items)
                print(f"    -> {len(chunk_result.items)} items")
            except Exception as e:
                print(f"    !! Chunk {chunk_start}-{chunk_end} failed: {e}")
            finally:
                for p in image_paths:
                    p.unlink(missing_ok=True)

        return ExtractionResult(source=source_label, items=all_items)

    def extract_from_text(self, text: str, source_label: str = "") -> ExtractionResult:
        """Extract mathematical items from raw text (for non-PDF sources)."""
        return self._extract_from_text_content(text, source_label)

    def _validate_result(self, data: dict, source_label: str) -> ExtractionResult:
        """Validate and normalize extraction output."""
        if isinstance(data, dict):
            if "items" not in data:
                data = {"source": source_label, "items": data if isinstance(data, list) else [data]}
            if "source" not in data:
                data["source"] = source_label
            return ExtractionResult.model_validate(data)
        return ExtractionResult(source=source_label, items=[])
