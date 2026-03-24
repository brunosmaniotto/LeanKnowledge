"""OpenDataLoader PDF extraction backend (Tier 2).

Uses opendataloader-pdf to extract text from PDFs with better handling
of complex layouts, tables, and mathematical notation than plain PyMuPDF.
"""

import tempfile
from pathlib import Path


class OpenDataLoaderExtractor:
    """Wraps opendataloader-pdf for PDF text extraction."""

    @staticmethod
    def is_available() -> bool:
        """Check if opendataloader-pdf is installed."""
        try:
            import opendataloader_pdf  # noqa: F401
            return True
        except ImportError:
            return False

    def extract(
        self,
        pdf_path: Path,
        start_page: int | None = None,
        end_page: int | None = None,
        hybrid: bool = False,
    ) -> str:
        """Extract text from a PDF using OpenDataLoader.

        Args:
            pdf_path: path to the PDF file
            start_page: first page (1-indexed). None = first page.
            end_page: last page (1-indexed, inclusive). None = last page.
            hybrid: enable hybrid mode (AI-assisted extraction for complex pages)

        Returns:
            Extracted text with page separators.
        """
        from opendataloader_pdf import convert

        with tempfile.TemporaryDirectory() as tmpdir:
            # Build page range string
            pages = None
            if start_page is not None or end_page is not None:
                s = start_page or 1
                e = end_page or 9999
                pages = f"{s}-{e}"

            convert(
                input_path=str(pdf_path),
                output_dir=tmpdir,
                format="markdown",
                quiet=True,
                pages=pages,
                keep_line_breaks=True,
                markdown_page_separator="\n\n--- Page %page-number% ---\n\n",
                hybrid="docling-fast" if hybrid else None,
            )

            # Find the output file
            out_files = list(Path(tmpdir).glob("*.md"))
            if not out_files:
                raise RuntimeError(
                    f"OpenDataLoader produced no output for {pdf_path}"
                )

            return out_files[0].read_text(encoding="utf-8")
