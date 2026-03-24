"""Automated inbox feeder -- ingests PDFs/text and optionally formalizes.

Usage:
    feeder = Feeder(pipeline)
    result = feeder.feed_directory(Path("./pdfs"))
    result = feeder.feed_file(Path("textbook.pdf"))
    result = feeder.feed_text("Let G be a group...")
    feeder.watch(Path("./inbox"), interval=30)
"""

from __future__ import annotations

import hashlib
import json
import logging
import os
import time
from dataclasses import dataclass, field
from pathlib import Path
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from .pipeline import Pipeline

log = logging.getLogger(__name__)

# Supported file extensions for automatic scanning
PDF_EXTENSIONS = {".pdf"}
TEXT_EXTENSIONS = {".txt", ".md", ".tex", ".rst"}
ALL_EXTENSIONS = PDF_EXTENSIONS | TEXT_EXTENSIONS

FEED_HISTORY_FILENAME = ".feed_history.json"


# ---------------------------------------------------------------------------
# Result
# ---------------------------------------------------------------------------

@dataclass
class FeedResult:
    """Aggregate result of a feed operation."""

    files_processed: int = 0
    items_extracted: int = 0
    items_new: int = 0          # passed librarian dedup
    items_duplicate: int = 0    # caught by librarian
    items_formalized: int = 0   # successfully formalized (if auto_formalize=True)
    items_failed: int = 0
    errors: list[str] = field(default_factory=list)

    def merge(self, other: FeedResult) -> None:
        """Merge another FeedResult into this one (mutating)."""
        self.files_processed += other.files_processed
        self.items_extracted += other.items_extracted
        self.items_new += other.items_new
        self.items_duplicate += other.items_duplicate
        self.items_formalized += other.items_formalized
        self.items_failed += other.items_failed
        self.errors.extend(other.errors)


# ---------------------------------------------------------------------------
# Feed history (dedup tracking)
# ---------------------------------------------------------------------------

def _file_key(path: Path) -> str:
    """Stable key for a file based on resolved path + mtime + size."""
    stat = path.stat()
    raw = f"{path.resolve()}|{stat.st_mtime_ns}|{stat.st_size}"
    return hashlib.sha256(raw.encode()).hexdigest()


def _load_history(output_dir: Path) -> dict:
    """Load the feed history from the output directory."""
    history_path = output_dir / FEED_HISTORY_FILENAME
    if history_path.exists():
        try:
            return json.loads(history_path.read_text(encoding="utf-8"))
        except (json.JSONDecodeError, OSError):
            log.warning("Corrupt feed history at %s -- starting fresh", history_path)
    return {}


def _save_history(output_dir: Path, history: dict) -> None:
    """Persist the feed history to the output directory."""
    output_dir.mkdir(parents=True, exist_ok=True)
    history_path = output_dir / FEED_HISTORY_FILENAME
    history_path.write_text(json.dumps(history, indent=2), encoding="utf-8")


# ---------------------------------------------------------------------------
# Feeder
# ---------------------------------------------------------------------------

class Feeder:
    """Automated inbox feeder -- ingests PDFs/text and optionally formalizes."""

    def __init__(
        self,
        pipeline: Pipeline,
        chunk_pages: int = 20,
        auto_formalize: bool = False,
    ):
        self.pipeline = pipeline
        self.chunk_pages = max(1, chunk_pages)
        self.auto_formalize = auto_formalize
        self._processed: set[str] = set()  # in-memory dedup for watch mode

    # ------------------------------------------------------------------
    # Public API
    # ------------------------------------------------------------------

    def feed_directory(
        self,
        dir_path: Path,
        recursive: bool = False,
    ) -> FeedResult:
        """Process all PDFs and text files in a directory.

        Args:
            dir_path: Directory to scan.
            recursive: If True, scan subdirectories too.

        Returns:
            Aggregated FeedResult for all files.
        """
        dir_path = Path(dir_path)
        if not dir_path.is_dir():
            return FeedResult(errors=[f"Not a directory: {dir_path}"])

        files = self._collect_files(dir_path, recursive)
        if not files:
            print(f"No supported files found in {dir_path}")
            return FeedResult()

        history = _load_history(self.pipeline.output_dir)
        result = FeedResult()

        for fpath in sorted(files):
            key = _file_key(fpath)
            if key in history or key in self._processed:
                log.info("Skipping already-processed file: %s", fpath)
                continue

            print(f"\n--- Processing: {fpath.name} ---")
            try:
                file_result = self._process_file(fpath)
                result.merge(file_result)
                # Record in history
                history[key] = {
                    "path": str(fpath.resolve()),
                    "processed_at": time.strftime("%Y-%m-%dT%H:%M:%S"),
                }
                self._processed.add(key)
            except Exception as exc:
                msg = f"{fpath.name}: {exc}"
                log.error("Failed to process %s: %s", fpath, exc)
                result.errors.append(msg)

        _save_history(self.pipeline.output_dir, history)

        # Auto-formalize if requested
        if self.auto_formalize and result.items_new > 0:
            result = self._run_formalize(result)

        self._print_summary(result)
        return result

    def feed_file(self, file_path: Path) -> FeedResult:
        """Process a single file (PDF or text).

        Args:
            file_path: Path to the file.

        Returns:
            FeedResult for this file.
        """
        file_path = Path(file_path)
        if not file_path.is_file():
            return FeedResult(errors=[f"File not found: {file_path}"])

        history = _load_history(self.pipeline.output_dir)
        key = _file_key(file_path)
        if key in history:
            print(f"Already processed: {file_path.name}")
            return FeedResult()

        print(f"\n--- Processing: {file_path.name} ---")
        try:
            result = self._process_file(file_path)
        except Exception as exc:
            result = FeedResult(errors=[f"{file_path.name}: {exc}"])

        # Record in history
        history[key] = {
            "path": str(file_path.resolve()),
            "processed_at": time.strftime("%Y-%m-%dT%H:%M:%S"),
        }
        self._processed.add(key)
        _save_history(self.pipeline.output_dir, history)

        # Auto-formalize if requested
        if self.auto_formalize and result.items_new > 0:
            result = self._run_formalize(result)

        self._print_summary(result)
        return result

    def feed_text(self, text: str, source_label: str = "") -> FeedResult:
        """Process raw text directly.

        Args:
            text: Mathematical text to extract claims from.
            source_label: Human-readable label for the source.

        Returns:
            FeedResult for this text.
        """
        if not text.strip():
            return FeedResult(errors=["Empty text provided"])

        backlog_before = len(self.pipeline.backlog.entries)

        try:
            extraction = self.pipeline.extract_text(text, source_label=source_label)
            items_extracted = len(extraction.items)
        except Exception as exc:
            return FeedResult(errors=[f"Text extraction failed: {exc}"])

        backlog_after = len(self.pipeline.backlog.entries)
        items_new = backlog_after - backlog_before
        items_duplicate = items_extracted - items_new

        result = FeedResult(
            files_processed=1,
            items_extracted=items_extracted,
            items_new=items_new,
            items_duplicate=items_duplicate,
        )

        if self.auto_formalize and items_new > 0:
            result = self._run_formalize(result)

        self._print_summary(result)
        return result

    def watch(self, dir_path: Path, interval: float = 30.0) -> None:
        """Watch a directory for new files, process them as they appear.

        Polls every ``interval`` seconds.  Ctrl+C to stop.

        Args:
            dir_path: Directory to watch.
            interval: Seconds between polls.
        """
        dir_path = Path(dir_path)
        if not dir_path.is_dir():
            print(f"Not a directory: {dir_path}")
            return

        print(f"Watching {dir_path} (poll every {interval}s). Ctrl+C to stop.")

        # Load existing history so we skip already-processed files
        history = _load_history(self.pipeline.output_dir)
        self._processed = set(history.keys())

        try:
            while True:
                files = self._collect_files(dir_path, recursive=False)
                new_files = []
                for fpath in files:
                    key = _file_key(fpath)
                    if key not in self._processed:
                        new_files.append(fpath)

                if new_files:
                    print(f"\n[watch] Found {len(new_files)} new file(s)")
                    for fpath in sorted(new_files):
                        key = _file_key(fpath)
                        print(f"\n--- Processing: {fpath.name} ---")
                        try:
                            file_result = self._process_file(fpath)
                            self._print_summary(file_result)
                            history[key] = {
                                "path": str(fpath.resolve()),
                                "processed_at": time.strftime("%Y-%m-%dT%H:%M:%S"),
                            }
                            self._processed.add(key)
                        except Exception as exc:
                            log.error("Failed: %s: %s", fpath, exc)
                            print(f"  ERROR: {fpath.name}: {exc}")

                    _save_history(self.pipeline.output_dir, history)

                    # Auto-formalize batch after processing new files
                    if self.auto_formalize:
                        self._run_formalize(FeedResult())

                time.sleep(interval)
        except KeyboardInterrupt:
            print("\n[watch] Stopped.")

    # ------------------------------------------------------------------
    # Internals
    # ------------------------------------------------------------------

    def _collect_files(self, dir_path: Path, recursive: bool) -> list[Path]:
        """Collect supported files from a directory."""
        if recursive:
            files = [
                p for p in dir_path.rglob("*")
                if p.is_file() and p.suffix.lower() in ALL_EXTENSIONS
            ]
        else:
            files = [
                p for p in dir_path.iterdir()
                if p.is_file() and p.suffix.lower() in ALL_EXTENSIONS
            ]
        return files

    def _process_file(self, file_path: Path) -> FeedResult:
        """Process a single file and return a FeedResult."""
        suffix = file_path.suffix.lower()

        backlog_before = len(self.pipeline.backlog.entries)

        if suffix in PDF_EXTENSIONS:
            items_extracted = self._process_pdf(file_path)
        elif suffix in TEXT_EXTENSIONS:
            items_extracted = self._process_text_file(file_path)
        else:
            return FeedResult(errors=[f"Unsupported file type: {suffix}"])

        backlog_after = len(self.pipeline.backlog.entries)
        items_new = backlog_after - backlog_before
        items_duplicate = items_extracted - items_new

        return FeedResult(
            files_processed=1,
            items_extracted=items_extracted,
            items_new=items_new,
            items_duplicate=items_duplicate,
        )

    def _process_pdf(self, pdf_path: Path) -> int:
        """Process a PDF in chunks. Returns total items extracted."""
        import pymupdf

        doc = pymupdf.open(str(pdf_path))
        total_pages = len(doc)
        doc.close()

        source_label = pdf_path.stem
        total_items = 0

        for chunk_start in range(1, total_pages + 1, self.chunk_pages):
            chunk_end = min(chunk_start + self.chunk_pages - 1, total_pages)
            print(f"  Chunk: pages {chunk_start}-{chunk_end} of {total_pages}")

            extraction = self.pipeline.extract(
                pdf_path,
                start_page=chunk_start,
                end_page=chunk_end,
                source_label=f"{source_label} pp.{chunk_start}-{chunk_end}",
            )
            total_items += len(extraction.items)

        return total_items

    def _process_text_file(self, text_path: Path) -> int:
        """Process a text file. Returns total items extracted."""
        text = text_path.read_text(encoding="utf-8")
        if not text.strip():
            return 0

        extraction = self.pipeline.extract_text(
            text, source_label=text_path.stem,
        )
        return len(extraction.items)

    def _run_formalize(self, result: FeedResult) -> FeedResult:
        """Run formalize_all and update the result counts."""
        print("\n=== Auto-formalizing new items ===")
        formalize_results = self.pipeline.formalize_all()
        result.items_formalized = sum(1 for r in formalize_results if r.success)
        result.items_failed = sum(1 for r in formalize_results if not r.success)
        return result

    @staticmethod
    def _print_summary(result: FeedResult) -> None:
        """Print a human-readable summary of the feed result."""
        print(f"\n  Feed summary:")
        print(f"    Files processed:   {result.files_processed}")
        print(f"    Items extracted:   {result.items_extracted}")
        print(f"    Items new:         {result.items_new}")
        print(f"    Items duplicate:   {result.items_duplicate}")
        if result.items_formalized or result.items_failed:
            print(f"    Items formalized:  {result.items_formalized}")
            print(f"    Items failed:      {result.items_failed}")
        if result.errors:
            print(f"    Errors:            {len(result.errors)}")
            for err in result.errors:
                print(f"      - {err}")
