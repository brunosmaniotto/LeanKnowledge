"""Tests for the Feeder (automated inbox feeder).

All tests use mock extraction -- no LLM or PDF calls.
"""

import json
import time
from pathlib import Path
from unittest.mock import MagicMock, patch

import pytest

from leanknowledge.feeder import (
    Feeder,
    FeedResult,
    _file_key,
    _load_history,
    _save_history,
    FEED_HISTORY_FILENAME,
)
from leanknowledge.pipeline import Pipeline
from leanknowledge.schemas import (
    ExtractionResult,
    ExtractedItem,
    StatementType,
    ClaimRole,
)
from leanknowledge.backlog import BacklogStatus


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _fake_extraction(n_items: int = 2, source: str = "test") -> ExtractionResult:
    """Create a fake ExtractionResult with n items."""
    items = []
    for i in range(n_items):
        items.append(ExtractedItem(
            id=f"Item_{source}_{i}",
            type=StatementType.THEOREM,
            role=ClaimRole.CLAIMED_RESULT,
            statement=f"Statement {i} from {source}",
            proof=f"Proof {i}",
            section="1.A",
        ))
    return ExtractionResult(source=source, items=items)


def _make_pipeline(tmp_path: Path) -> Pipeline:
    """Create a Pipeline with output_dir pointing at tmp_path."""
    return Pipeline(output_dir=tmp_path)


def _make_pdf(dir_path: Path, name: str = "test.pdf") -> Path:
    """Create a minimal file that looks like a PDF (just for path-based testing)."""
    dir_path.mkdir(parents=True, exist_ok=True)
    path = dir_path / name
    # Write enough bytes that stat() gives a non-zero size
    path.write_bytes(b"%PDF-1.4 fake pdf content " * 10)
    return path


def _make_text_file(dir_path: Path, name: str = "notes.txt", content: str = "") -> Path:
    """Create a text file."""
    dir_path.mkdir(parents=True, exist_ok=True)
    path = dir_path / name
    path.write_text(content or "Let G be a group. Theorem: every group has an identity.", encoding="utf-8")
    return path


# ---------------------------------------------------------------------------
# FeedResult
# ---------------------------------------------------------------------------

class TestFeedResult:
    def test_defaults(self):
        r = FeedResult()
        assert r.files_processed == 0
        assert r.items_extracted == 0
        assert r.items_new == 0
        assert r.items_duplicate == 0
        assert r.items_formalized == 0
        assert r.items_failed == 0
        assert r.errors == []

    def test_merge(self):
        a = FeedResult(files_processed=1, items_extracted=3, items_new=2,
                       items_duplicate=1, errors=["err1"])
        b = FeedResult(files_processed=2, items_extracted=5, items_new=4,
                       items_duplicate=1, errors=["err2"])
        a.merge(b)
        assert a.files_processed == 3
        assert a.items_extracted == 8
        assert a.items_new == 6
        assert a.items_duplicate == 2
        assert a.errors == ["err1", "err2"]


# ---------------------------------------------------------------------------
# Feed history (dedup tracking)
# ---------------------------------------------------------------------------

class TestFeedHistory:
    def test_save_and_load(self, tmp_path):
        history = {"abc123": {"path": "/tmp/test.pdf", "processed_at": "2026-01-01"}}
        _save_history(tmp_path, history)

        loaded = _load_history(tmp_path)
        assert loaded == history

    def test_load_missing(self, tmp_path):
        loaded = _load_history(tmp_path)
        assert loaded == {}

    def test_load_corrupt(self, tmp_path):
        (tmp_path / FEED_HISTORY_FILENAME).write_text("not json", encoding="utf-8")
        loaded = _load_history(tmp_path)
        assert loaded == {}

    def test_file_key_deterministic(self, tmp_path):
        f = _make_text_file(tmp_path, "a.txt", "hello")
        k1 = _file_key(f)
        k2 = _file_key(f)
        assert k1 == k2

    def test_file_key_changes_with_content(self, tmp_path):
        f = _make_text_file(tmp_path, "b.txt", "version 1")
        k1 = _file_key(f)
        # Modify the file -- mtime and/or size change
        time.sleep(0.05)
        f.write_text("version 2 with different content!", encoding="utf-8")
        k2 = _file_key(f)
        assert k1 != k2


# ---------------------------------------------------------------------------
# feed_text
# ---------------------------------------------------------------------------

class TestFeedText:
    def test_feed_text_extracts_items(self, tmp_path):
        pipeline = _make_pipeline(tmp_path)
        feeder = Feeder(pipeline)

        fake_result = _fake_extraction(3, "inline")

        def mock_extract_text(text, source_label=""):
            # Simulate what pipeline.extract_text does: add items to backlog
            pipeline._ingest(fake_result)
            return fake_result

        with patch.object(pipeline, "extract_text", side_effect=mock_extract_text):
            result = feeder.feed_text("Some math text", source_label="inline")

        assert result.files_processed == 1
        assert result.items_extracted == 3
        # All 3 should be new (empty backlog)
        assert result.items_new == 3
        assert result.items_duplicate == 0

    def test_feed_text_empty(self, tmp_path):
        pipeline = _make_pipeline(tmp_path)
        feeder = Feeder(pipeline)
        result = feeder.feed_text("   ")
        assert result.errors == ["Empty text provided"]

    def test_feed_text_extraction_error(self, tmp_path):
        pipeline = _make_pipeline(tmp_path)
        feeder = Feeder(pipeline)

        with patch.object(pipeline, "extract_text", side_effect=RuntimeError("LLM down")):
            result = feeder.feed_text("Some text")

        assert len(result.errors) == 1
        assert "LLM down" in result.errors[0]


# ---------------------------------------------------------------------------
# feed_file
# ---------------------------------------------------------------------------

class TestFeedFile:
    def test_feed_text_file(self, tmp_path):
        pipeline = _make_pipeline(tmp_path)
        feeder = Feeder(pipeline)

        text_file = _make_text_file(tmp_path / "inputs", "notes.txt")
        fake_result = _fake_extraction(2, "notes")

        def mock_extract_text(text, source_label=""):
            pipeline._ingest(fake_result)
            return fake_result

        with patch.object(pipeline, "extract_text", side_effect=mock_extract_text):
            result = feeder.feed_file(text_file)

        assert result.files_processed == 1
        assert result.items_extracted == 2

    def test_feed_pdf_file(self, tmp_path):
        pipeline = _make_pipeline(tmp_path)
        feeder = Feeder(pipeline, chunk_pages=10)

        pdf_file = _make_pdf(tmp_path / "inputs")

        call_idx = [0]

        def mock_extract(pdf_path, start_page, end_page, source_label=""):
            call_idx[0] += 1
            # Use a unique source per chunk to avoid backlog dedup
            fake = _fake_extraction(5, f"test_chunk{call_idx[0]}")
            pipeline._ingest(fake)
            return fake

        # Mock pymupdf to report 15 pages (so 2 chunks: 1-10, 11-15)
        mock_doc = MagicMock()
        mock_doc.__len__ = MagicMock(return_value=15)
        mock_pymupdf = MagicMock()
        mock_pymupdf.open.return_value = mock_doc

        with patch.dict("sys.modules", {"pymupdf": mock_pymupdf}), \
             patch.object(pipeline, "extract", side_effect=mock_extract) as mock_ext:
            result = feeder.feed_file(pdf_file)

        assert result.files_processed == 1
        # 5 items per chunk * 2 chunks = 10 items
        assert result.items_extracted == 10
        # pipeline.extract should be called twice (2 chunks)
        assert mock_ext.call_count == 2

    def test_feed_file_not_found(self, tmp_path):
        pipeline = _make_pipeline(tmp_path)
        feeder = Feeder(pipeline)
        result = feeder.feed_file(tmp_path / "nonexistent.pdf")
        assert len(result.errors) == 1
        assert "not found" in result.errors[0].lower()

    def test_feed_file_dedup(self, tmp_path):
        """Same file not processed twice."""
        pipeline = _make_pipeline(tmp_path)
        feeder = Feeder(pipeline)

        text_file = _make_text_file(tmp_path / "inputs", "notes.txt")
        fake_result = _fake_extraction(2, "notes")

        def mock_extract_text(text, source_label=""):
            pipeline._ingest(fake_result)
            return fake_result

        with patch.object(pipeline, "extract_text", side_effect=mock_extract_text):
            result1 = feeder.feed_file(text_file)
            result2 = feeder.feed_file(text_file)

        assert result1.files_processed == 1
        assert result1.items_extracted == 2
        # Second call should be a no-op (already processed)
        assert result2.files_processed == 0
        assert result2.items_extracted == 0


# ---------------------------------------------------------------------------
# feed_directory
# ---------------------------------------------------------------------------

class TestFeedDirectory:
    def test_processes_all_files(self, tmp_path):
        pipeline = _make_pipeline(tmp_path / "output")
        feeder = Feeder(pipeline)

        inputs = tmp_path / "inputs"
        inputs.mkdir()
        _make_text_file(inputs, "a.txt")
        _make_text_file(inputs, "b.txt")
        # Unsupported file should be ignored
        (inputs / "image.png").write_bytes(b"PNG")

        call_idx = [0]

        def mock_extract_text(text, source_label=""):
            call_idx[0] += 1
            fake = _fake_extraction(1, f"file{call_idx[0]}")
            pipeline._ingest(fake)
            return fake

        with patch.object(pipeline, "extract_text", side_effect=mock_extract_text):
            result = feeder.feed_directory(inputs)

        assert result.files_processed == 2

    def test_recursive(self, tmp_path):
        pipeline = _make_pipeline(tmp_path / "output")
        feeder = Feeder(pipeline)

        inputs = tmp_path / "inputs"
        sub = inputs / "subdir"
        sub.mkdir(parents=True)
        _make_text_file(inputs, "top.txt")
        _make_text_file(sub, "nested.txt")

        call_idx = [0]

        def mock_extract_text(text, source_label=""):
            call_idx[0] += 1
            fake = _fake_extraction(1, f"file{call_idx[0]}")
            pipeline._ingest(fake)
            return fake

        with patch.object(pipeline, "extract_text", side_effect=mock_extract_text):
            result = feeder.feed_directory(inputs, recursive=True)

        assert result.files_processed == 2

    def test_non_recursive_skips_subdirs(self, tmp_path):
        pipeline = _make_pipeline(tmp_path / "output")
        feeder = Feeder(pipeline)

        inputs = tmp_path / "inputs"
        sub = inputs / "subdir"
        sub.mkdir(parents=True)
        _make_text_file(inputs, "top.txt")
        _make_text_file(sub, "nested.txt")

        def mock_extract_text(text, source_label=""):
            fake = _fake_extraction(1, "top")
            pipeline._ingest(fake)
            return fake

        with patch.object(pipeline, "extract_text", side_effect=mock_extract_text):
            result = feeder.feed_directory(inputs, recursive=False)

        # Only top-level file
        assert result.files_processed == 1

    def test_not_a_directory(self, tmp_path):
        pipeline = _make_pipeline(tmp_path)
        feeder = Feeder(pipeline)
        result = feeder.feed_directory(tmp_path / "nonexistent")
        assert len(result.errors) == 1
        assert "Not a directory" in result.errors[0]

    def test_empty_directory(self, tmp_path):
        pipeline = _make_pipeline(tmp_path / "output")
        feeder = Feeder(pipeline)

        inputs = tmp_path / "inputs"
        inputs.mkdir()

        result = feeder.feed_directory(inputs)
        assert result.files_processed == 0

    def test_error_continues_to_next(self, tmp_path):
        """If one file fails, processing continues to the next."""
        pipeline = _make_pipeline(tmp_path / "output")
        feeder = Feeder(pipeline)

        inputs = tmp_path / "inputs"
        inputs.mkdir()
        _make_text_file(inputs, "good.txt", "Valid math content")
        _make_text_file(inputs, "bad.txt", "Will fail")

        good_result = _fake_extraction(2, "good")

        def side_effect(text, source_label=""):
            if "Will fail" in text:
                raise RuntimeError("Extraction crashed")
            pipeline._ingest(good_result)
            return good_result

        with patch.object(pipeline, "extract_text", side_effect=side_effect):
            result = feeder.feed_directory(inputs)

        # One succeeded, one failed
        assert result.files_processed == 1
        assert len(result.errors) == 1
        assert "crashed" in result.errors[0].lower()

    def test_dedup_across_calls(self, tmp_path):
        """Files processed in one call are skipped in subsequent calls."""
        pipeline = _make_pipeline(tmp_path / "output")
        feeder = Feeder(pipeline)

        inputs = tmp_path / "inputs"
        inputs.mkdir()
        _make_text_file(inputs, "a.txt")

        def mock_extract_text(text, source_label=""):
            fake = _fake_extraction(1, "a")
            pipeline._ingest(fake)
            return fake

        with patch.object(pipeline, "extract_text", side_effect=mock_extract_text):
            r1 = feeder.feed_directory(inputs)
            r2 = feeder.feed_directory(inputs)

        assert r1.files_processed == 1
        assert r2.files_processed == 0


# ---------------------------------------------------------------------------
# Auto-formalize
# ---------------------------------------------------------------------------

class TestAutoFormalize:
    def test_formalize_flag(self, tmp_path):
        pipeline = _make_pipeline(tmp_path)
        feeder = Feeder(pipeline, auto_formalize=True)

        fake_result = _fake_extraction(2, "inline")

        def mock_extract_text(text, source_label=""):
            pipeline._ingest(fake_result)
            return fake_result

        mock_formalize = MagicMock(return_value=[
            MagicMock(success=True),
            MagicMock(success=False),
        ])

        with patch.object(pipeline, "extract_text", side_effect=mock_extract_text), \
             patch.object(pipeline, "formalize_all", mock_formalize):
            result = feeder.feed_text("math text", source_label="inline")

        assert result.items_formalized == 1
        assert result.items_failed == 1
        mock_formalize.assert_called_once()

    def test_no_formalize_by_default(self, tmp_path):
        pipeline = _make_pipeline(tmp_path)
        feeder = Feeder(pipeline, auto_formalize=False)

        fake_result = _fake_extraction(2, "inline")

        def mock_extract_text(text, source_label=""):
            pipeline._ingest(fake_result)
            return fake_result

        with patch.object(pipeline, "extract_text", side_effect=mock_extract_text), \
             patch.object(pipeline, "formalize_all") as mock_formalize:
            result = feeder.feed_text("math text", source_label="inline")

        mock_formalize.assert_not_called()
        assert result.items_formalized == 0


# ---------------------------------------------------------------------------
# Watch mode
# ---------------------------------------------------------------------------

class TestWatchMode:
    def test_watch_not_a_directory(self, tmp_path, capsys):
        pipeline = _make_pipeline(tmp_path)
        feeder = Feeder(pipeline)
        feeder.watch(tmp_path / "nonexistent", interval=1)
        captured = capsys.readouterr()
        assert "Not a directory" in captured.out

    def test_watch_detects_new_files(self, tmp_path):
        """Test that watch mode detects new files on each poll iteration."""
        pipeline = _make_pipeline(tmp_path / "output")
        feeder = Feeder(pipeline)

        watch_dir = tmp_path / "inbox"
        watch_dir.mkdir()

        call_idx = [0]

        def mock_extract_text(text, source_label=""):
            call_idx[0] += 1
            fake = _fake_extraction(1, f"watch_{call_idx[0]}")
            pipeline._ingest(fake)
            return fake

        iteration = 0

        def mock_sleep(seconds):
            nonlocal iteration
            iteration += 1
            if iteration == 1:
                # Add a file after first sleep
                _make_text_file(watch_dir, "new.txt", "new theorem")
            elif iteration >= 2:
                # Stop after second iteration
                raise KeyboardInterrupt()

        with patch.object(pipeline, "extract_text", side_effect=mock_extract_text), \
             patch("leanknowledge.feeder.time.sleep", side_effect=mock_sleep):
            feeder.watch(watch_dir, interval=0.01)

        # The _processed set should have at least one entry (the file key hash)
        assert len(feeder._processed) >= 1
