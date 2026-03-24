"""Tests for Agent 7: Failure Analyst — clustering, lessons, retry selection."""

import json
import pytest
from pathlib import Path

from leanknowledge.schemas import (
    ExtractedItem, StatementType, ClaimRole, ErrorCategory,
)
from leanknowledge.agents.triage import ItemCategory
from leanknowledge.backlog import Backlog, BacklogEntry, BacklogStatus
from leanknowledge.agents.failure_analyst import (
    FailureAnalyst, FailureCluster, FailureLesson, AnalysisReport,
    build_retry_context,
)
from leanknowledge.prompt_tuner import PromptTuner


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _item(id: str, statement: str = "test", deps=None) -> ExtractedItem:
    return ExtractedItem(
        id=id, type=StatementType.THEOREM, role=ClaimRole.CLAIMED_RESULT,
        statement=statement, section="1.A", labeled=True,
        dependencies=deps or [],
    )


def _failed_entry(id: str, reason: str = "type mismatch") -> BacklogEntry:
    return BacklogEntry(
        item=_item(id),
        category=ItemCategory.THEOREM,
        status=BacklogStatus.FAILED,
        failure_reason=reason,
    )


def _write_triples(output_dir: Path, item_id: str, triples: list[dict]):
    """Write mock triples to the expected directory structure."""
    triples_dir = output_dir / "triples"
    triples_dir.mkdir(parents=True, exist_ok=True)
    safe = item_id.lower().replace(" ", "_").replace("/", "_")
    path = triples_dir / f"{safe}_20260318_120000.json"
    path.write_text(json.dumps(triples, indent=2), encoding="utf-8")


def _write_failure(output_dir: Path, item_id: str, record: dict):
    """Write a mock failure record."""
    failures_dir = output_dir / "failures"
    failures_dir.mkdir(parents=True, exist_ok=True)
    safe = item_id.lower().replace(" ", "_").replace("/", "_")
    path = failures_dir / f"{safe}.json"
    path.write_text(json.dumps(record, indent=2), encoding="utf-8")


# ---------------------------------------------------------------------------
# Phase 1: Clustering
# ---------------------------------------------------------------------------

class TestClustering:
    def test_clusters_by_error_category(self, tmp_path):
        """Items with the same error type should be clustered together."""
        analyst = FailureAnalyst()
        entries = [_failed_entry("T1"), _failed_entry("T2"), _failed_entry("T3")]

        # Write triples with type mismatch errors for all three
        for entry in entries:
            _write_triples(tmp_path, entry.item.id, [
                {
                    "compiled": False,
                    "compiler_output": "Scratch.lean:10:4: error: type mismatch\n  expected ℕ\n  got ℤ",
                    "lean_code": "theorem t : True := sorry",
                },
            ])

        clusters = analyst._cluster_failures(entries, tmp_path)
        assert len(clusters) >= 1
        # All three items should be in the same cluster
        cat_clusters = [c for c in clusters if c.error_category == ErrorCategory.TYPE_MISMATCH]
        assert len(cat_clusters) >= 1
        assert cat_clusters[0].count >= 2

    def test_no_clusters_for_unique_errors(self, tmp_path):
        """Each item has a unique error — no clusters (min size 2)."""
        analyst = FailureAnalyst()
        entries = [_failed_entry("T1")]

        _write_triples(tmp_path, "T1", [
            {
                "compiled": False,
                "compiler_output": "Scratch.lean:5:0: error: some unique error xyz123",
                "lean_code": "theorem t : True := sorry",
            },
        ])

        clusters = analyst._cluster_failures(entries, tmp_path)
        # Single item can't form a cluster
        assert all(c.count >= 2 for c in clusters)

    def test_clusters_from_failure_records(self, tmp_path):
        """Falls back to failure records when triples are missing."""
        analyst = FailureAnalyst()
        entries = [_failed_entry("T1"), _failed_entry("T2")]

        # Write failure records instead of triples
        for entry in entries:
            _write_failure(tmp_path, entry.item.id, {
                "item_id": entry.item.id,
                "last_compiler_error": "unknown constant `Nat.bogus_lemma`",
                "cause": "hallucinated_identifier",
            })

        clusters = analyst._cluster_failures(entries, tmp_path)
        assert len(clusters) >= 1

    def test_empty_entries(self, tmp_path):
        """No entries → no clusters."""
        analyst = FailureAnalyst()
        clusters = analyst._cluster_failures([], tmp_path)
        assert clusters == []

    def test_normalize_error_strips_paths(self):
        """Normalization should strip file paths and line numbers."""
        norm = FailureAnalyst._normalize_error(
            "C:/Users/test/Scratch.lean:42:8: error: type mismatch"
        )
        assert "C:/Users" not in norm
        assert "42:8" not in norm

    def test_normalize_error_strips_identifiers(self):
        """Normalization should replace specific identifier names."""
        norm = FailureAnalyst._normalize_error(
            "unknown constant `Nat.bogus_lemma_xyz`"
        )
        assert "bogus_lemma_xyz" not in norm
        assert "`ID`" in norm


# ---------------------------------------------------------------------------
# Phase 2: Lesson generation
# ---------------------------------------------------------------------------

class TestLessonGeneration:
    def test_generates_lessons_for_clusters(self, tmp_path):
        analyst = FailureAnalyst()
        clusters = [
            FailureCluster(
                cluster_id="type_mismatch:type mismatch",
                error_category=ErrorCategory.TYPE_MISMATCH,
                normalized_key="type mismatch",
                count=5,
                affected_items=["T1", "T2", "T3", "T4", "T5"],
                example_errors=["type mismatch\n  expected ℕ\n  got ℤ"],
            ),
        ]
        lessons = analyst._generate_lessons(clusters, tmp_path)
        assert len(lessons) >= 1
        assert "cast" in lessons[0].lesson_text.lower() or "type" in lessons[0].lesson_text.lower()

    def test_severity_based_on_count(self, tmp_path):
        analyst = FailureAnalyst()
        high_cluster = FailureCluster(
            cluster_id="tactic:unsolved goals",
            error_category=ErrorCategory.TACTIC,
            normalized_key="unsolved goals",
            count=5,
            affected_items=["T1", "T2", "T3", "T4", "T5"],
        )
        low_cluster = FailureCluster(
            cluster_id="syntax:unexpected",
            error_category=ErrorCategory.SYNTAX,
            normalized_key="unexpected token",
            count=2,
            affected_items=["T6", "T7"],
        )
        lessons = analyst._generate_lessons([high_cluster, low_cluster], tmp_path)
        severities = {l.cluster_id: l.severity for l in lessons}
        assert severities["tactic:unsolved goals"] == "high"
        assert severities["syntax:unexpected"] == "medium"

    def test_missing_lemma_lesson_fills_template(self, tmp_path):
        analyst = FailureAnalyst()
        clusters = [
            FailureCluster(
                cluster_id="missing_lemma:unknown constant",
                error_category=ErrorCategory.MISSING_LEMMA,
                normalized_key="unknown constant `ID`",
                count=3,
                affected_items=["T1", "T2", "T3"],
                example_errors=[
                    "unknown constant `Nat.bogus_lemma`",
                    "unknown constant `Real.fake_thing`",
                ],
            ),
        ]
        lessons = analyst._generate_lessons(clusters, tmp_path)
        assert len(lessons) >= 1
        # Should contain the extracted hallucinated names
        text = lessons[0].lesson_text
        assert "Nat.bogus_lemma" in text or "exact?" in text

    def test_no_clusters_no_lessons(self, tmp_path):
        analyst = FailureAnalyst()
        lessons = analyst._generate_lessons([], tmp_path)
        assert lessons == []


# ---------------------------------------------------------------------------
# Phase 3: Retry selection
# ---------------------------------------------------------------------------

class TestRetrySelection:
    def test_retries_items_with_lessons(self):
        analyst = FailureAnalyst()
        entries = [_failed_entry("T1"), _failed_entry("T2")]
        clusters = [
            FailureCluster(
                cluster_id="type_mismatch:foo",
                error_category=ErrorCategory.TYPE_MISMATCH,
                normalized_key="foo",
                count=2,
                affected_items=["T1", "T2"],
            ),
        ]
        retry, skip = analyst._select_retries(entries, clusters, cycle=0)
        assert "T1" in retry
        assert "T2" in retry

    def test_skips_over_max_retry_count(self):
        analyst = FailureAnalyst()
        entry = _failed_entry("T1")
        entry.retry_count = 5  # exceeds MAX_RETRY_CYCLES
        clusters = [
            FailureCluster(
                cluster_id="type_mismatch:foo",
                error_category=ErrorCategory.TYPE_MISMATCH,
                normalized_key="foo",
                count=2,
                affected_items=["T1"],
            ),
        ]
        retry, skip = analyst._select_retries([entry], clusters, cycle=0)
        assert "T1" in skip
        assert "T1" not in retry

    def test_skips_crash_failures(self):
        analyst = FailureAnalyst()
        entry = _failed_entry("T1", reason="crash: unexpected exception in translator")
        retry, skip = analyst._select_retries([entry], [], cycle=0)
        assert "T1" in skip

    def test_retries_operational_failures(self):
        analyst = FailureAnalyst()
        entry = _failed_entry("T1", reason="empty or vacuous code")
        retry, skip = analyst._select_retries([entry], [], cycle=0)
        assert "T1" in retry

    def test_skips_when_cycle_exceeds_max(self):
        analyst = FailureAnalyst()
        entry = _failed_entry("T1")
        retry, skip = analyst._select_retries([entry], [], cycle=10)
        assert "T1" in skip


# ---------------------------------------------------------------------------
# Full analysis flow
# ---------------------------------------------------------------------------

class TestAnalyze:
    def test_full_analysis_flow(self, tmp_path):
        """End-to-end: cluster → lessons → retry selection."""
        analyst = FailureAnalyst()
        entries = [_failed_entry("T1"), _failed_entry("T2"), _failed_entry("T3")]

        for entry in entries:
            _write_triples(tmp_path, entry.item.id, [
                {
                    "compiled": False,
                    "compiler_output": "Scratch.lean:10:4: error: unknown constant `Nat.fake`",
                    "lean_code": "import Mathlib\ntheorem t : True := Nat.fake",
                },
            ])

        report = analyst.analyze(entries, tmp_path, cycle=0)
        assert isinstance(report, AnalysisReport)
        assert len(report.clusters) >= 1
        assert len(report.lessons) >= 1
        assert len(report.retry_items) >= 1

    def test_report_serializable(self, tmp_path):
        """AnalysisReport.to_dict() produces valid JSON."""
        report = AnalysisReport(
            clusters=[
                FailureCluster(
                    cluster_id="test:foo",
                    error_category=ErrorCategory.TACTIC,
                    normalized_key="foo",
                    count=3,
                    affected_items=["T1", "T2", "T3"],
                ),
            ],
            lessons=[
                FailureLesson(
                    cluster_id="test:foo",
                    severity="high",
                    lesson_text="Try omega.",
                    affected_items=["T1", "T2", "T3"],
                ),
            ],
            retry_items=["T1", "T2"],
            skip_items=["T3"],
            cycle=1,
        )
        data = report.to_dict()
        serialized = json.dumps(data)
        assert "test:foo" in serialized


# ---------------------------------------------------------------------------
# Retry context builder
# ---------------------------------------------------------------------------

class TestRetryContext:
    def test_builds_context_with_lessons(self, tmp_path):
        lessons = [
            FailureLesson(
                cluster_id="type_mismatch:cast",
                severity="high",
                lesson_text="Use push_cast for type coercion.",
                affected_items=["T1"],
            ),
        ]
        ctx = build_retry_context("T1", tmp_path, lessons)
        assert "push_cast" in ctx
        assert "Cross-theorem" in ctx

    def test_builds_context_with_triples(self, tmp_path):
        _write_triples(tmp_path, "T1", [
            {"compiled": False, "compiler_output": "error: type mismatch", "lean_code": "sorry"},
            {"compiled": False, "compiler_output": "error: unsolved goals", "lean_code": "sorry"},
            {"compiled": False, "compiler_output": "error: timeout", "lean_code": "sorry"},
            {"compiled": False, "compiler_output": "error: unknown", "lean_code": "sorry"},
        ])
        ctx = build_retry_context("T1", tmp_path, [], max_triples=3)
        # Should include last 3, not all 4
        assert "Previous attempts" in ctx
        assert ctx.count("Attempt") == 3

    def test_empty_context_when_no_data(self, tmp_path):
        ctx = build_retry_context("T1", tmp_path, [])
        assert ctx == ""


# ---------------------------------------------------------------------------
# Backlog integration
# ---------------------------------------------------------------------------

class TestBacklogRetry:
    def test_mark_retry_transitions_to_ready(self):
        bl = Backlog()
        bl.add(BacklogEntry(item=_item("T1"), category=ItemCategory.THEOREM))
        bl.mark_in_progress("T1")
        bl.mark_failed("T1", reason="type mismatch")
        assert bl.get("T1").status == BacklogStatus.FAILED

        bl.mark_retry("T1", retry_context="Use push_cast")
        assert bl.get("T1").status == BacklogStatus.READY
        assert bl.get("T1").retry_count == 1
        assert bl.get("T1").retry_context == "Use push_cast"
        assert bl.get("T1").failure_reason is None  # cleared

    def test_retry_count_increments(self):
        bl = Backlog()
        bl.add(BacklogEntry(item=_item("T1"), category=ItemCategory.THEOREM))
        bl.mark_in_progress("T1")
        bl.mark_failed("T1", reason="error")
        bl.mark_retry("T1")
        assert bl.get("T1").retry_count == 1

        # Simulate second failure + retry
        bl.mark_in_progress("T1")
        bl.mark_failed("T1", reason="error again")
        bl.mark_retry("T1")
        assert bl.get("T1").retry_count == 2

    def test_retry_status_in_stats(self):
        bl = Backlog()
        entry = BacklogEntry(
            item=_item("T1"), category=ItemCategory.THEOREM,
            status=BacklogStatus.RETRY,
        )
        bl.entries["T1"] = entry
        assert "retry" in bl.stats

    def test_failed_query(self):
        bl = Backlog()
        bl.add(BacklogEntry(item=_item("T1"), category=ItemCategory.THEOREM))
        bl.mark_in_progress("T1")
        bl.mark_failed("T1", reason="error")
        assert len(bl.failed()) == 1
        assert bl.failed()[0].item.id == "T1"


# ---------------------------------------------------------------------------
# PromptTuner integration
# ---------------------------------------------------------------------------

class TestPromptTunerIntegration:
    def test_failure_lessons_appear_in_output(self):
        tuner = PromptTuner()
        tuner.add_failure_lessons([
            FailureLesson(
                cluster_id="type_mismatch:cast",
                severity="high",
                lesson_text="Always use push_cast for ℕ→ℝ coercion.",
                affected_items=["T1"],
            ),
        ])
        lessons = tuner.get_lessons()
        assert "Cross-theorem failure analysis" in lessons
        assert "push_cast" in lessons

    def test_failure_lessons_persist(self, tmp_path):
        tuner = PromptTuner()
        tuner.add_failure_lessons([
            FailureLesson(
                cluster_id="test:foo",
                severity="medium",
                lesson_text="Test lesson.",
                affected_items=["T1"],
            ),
        ])

        path = tmp_path / "failure_lessons.json"
        tuner.save_failure_lessons(path)

        tuner2 = PromptTuner()
        tuner2.load_failure_lessons(path)
        assert len(tuner2._failure_lessons) == 1
        assert tuner2._failure_lessons[0]["lesson_text"] == "Test lesson."

    def test_stats_include_failure_lessons(self):
        tuner = PromptTuner()
        tuner.add_failure_lessons([
            FailureLesson(
                cluster_id="x", severity="low", lesson_text="y",
            ),
        ])
        assert tuner.stats["failure_lessons"] == 1
