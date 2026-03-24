"""Tests for the pipeline dashboard module."""

import json
from datetime import datetime, timedelta
from pathlib import Path

import pytest

from leanknowledge.dashboard import (
    DashboardStats,
    format_dashboard,
    load_backlog_entries,
    load_failure_records,
    load_results_summaries,
    load_triples,
    load_work_queue,
    run_dashboard,
)
from leanknowledge.backlog import BacklogEntry, BacklogStatus
from leanknowledge.agents.triage import ItemCategory
from leanknowledge.schemas import (
    ExtractedItem, StatementType, ClaimRole, ErrorCategory,
)


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _item(id: str, section: str = "Algebra") -> ExtractedItem:
    return ExtractedItem(
        id=id, type=StatementType.THEOREM, role=ClaimRole.CLAIMED_RESULT,
        statement=f"Statement of {id}", section=section, labeled=True,
    )


def _backlog_dict(
    id: str,
    status: str = "completed",
    section: str = "Algebra",
    attempts: int = 1,
    added_at: str | None = None,
    completed_at: str | None = None,
    failure_reason: str | None = None,
) -> dict:
    """Build a serialized BacklogEntry dict."""
    return {
        "item": {
            "id": id,
            "type": "theorem",
            "role": "claimed_result",
            "statement": f"Statement of {id}",
            "section": section,
            "labeled": True,
            "dependencies": [],
            "notation_in_scope": {},
        },
        "category": "theorem",
        "status": status,
        "dependency_info": None,
        "lean_file": f"lean/{id}.lean" if status == "completed" else None,
        "failure_reason": failure_reason,
        "attempts": attempts,
        "added_at": added_at or "2026-03-10T10:00:00",
        "completed_at": completed_at,
    }


def _triple_dict(
    compiled: bool = False,
    compiler_output: str = "",
    model: str = "deepseek/deepseek-reasoner",
    attempt_number: int = 1,
) -> dict:
    return {
        "structured_proof": {
            "theorem_name": "T",
            "strategy": "direct",
            "goal_statement": "test",
            "assumptions": [],
            "dependencies": [],
            "steps": [],
            "conclusion": "test",
        },
        "lean_code": "theorem t : True := trivial" if compiled else "invalid code",
        "compiler_output": compiler_output,
        "compiled": compiled,
        "model": model,
        "attempt_number": attempt_number,
        "reasoning": "",
    }


def _write_json(path: Path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2), encoding="utf-8")


# ---------------------------------------------------------------------------
# Tests: empty output directory
# ---------------------------------------------------------------------------

class TestEmptyDir:
    def test_empty_dir_returns_zeros(self, tmp_path):
        output = run_dashboard(tmp_path)
        assert "0/0" in output
        assert "EMPTY" in output

    def test_empty_stats(self, tmp_path):
        stats = DashboardStats([], [], [], [], tmp_path)
        assert stats.total == 0
        assert stats.completed == 0
        assert stats.failed == 0
        assert stats.success_rate == 0.0
        assert stats.avg_attempts == 0.0


# ---------------------------------------------------------------------------
# Tests: loading backlog entries
# ---------------------------------------------------------------------------

class TestLoadBacklog:
    def test_flat_layout(self, tmp_path):
        data = {
            "T1": _backlog_dict("T1", status="completed", attempts=3),
            "T2": _backlog_dict("T2", status="failed", failure_reason="type mismatch"),
        }
        _write_json(tmp_path / "backlog.json", data)

        entries = load_backlog_entries(tmp_path)
        assert len(entries) == 2
        statuses = {e.item.id: e.status for e in entries}
        assert statuses["T1"] == BacklogStatus.COMPLETED
        assert statuses["T2"] == BacklogStatus.FAILED

    def test_worker_layout(self, tmp_path):
        w0 = tmp_path / "worker_0"
        w1 = tmp_path / "worker_1"
        _write_json(
            w0 / "backlog.json",
            {"T1": _backlog_dict("T1", status="completed")},
        )
        _write_json(
            w1 / "backlog.json",
            {"T2": _backlog_dict("T2", status="failed")},
        )

        entries = load_backlog_entries(tmp_path)
        assert len(entries) == 2

    def test_worker_dedup(self, tmp_path):
        """If same item appears in two workers, last one wins."""
        w0 = tmp_path / "worker_0"
        w1 = tmp_path / "worker_1"
        _write_json(
            w0 / "backlog.json",
            {"T1": _backlog_dict("T1", status="ready")},
        )
        _write_json(
            w1 / "backlog.json",
            {"T1": _backlog_dict("T1", status="completed")},
        )

        entries = load_backlog_entries(tmp_path)
        assert len(entries) == 1
        assert entries[0].status == BacklogStatus.COMPLETED

    def test_malformed_entry_skipped(self, tmp_path):
        data = {
            "T1": _backlog_dict("T1"),
            "T2": {"garbage": True},
        }
        _write_json(tmp_path / "backlog.json", data)

        entries = load_backlog_entries(tmp_path)
        assert len(entries) == 1


# ---------------------------------------------------------------------------
# Tests: loading triples
# ---------------------------------------------------------------------------

class TestLoadTriples:
    def test_flat_triples(self, tmp_path):
        td = tmp_path / "triples"
        _write_json(td / "t1_20260310_120000.json", [
            _triple_dict(compiled=False, compiler_output="error: type mismatch"),
            _triple_dict(compiled=True, compiler_output=""),
        ])

        triples = load_triples(tmp_path)
        assert len(triples) == 2
        assert triples[1]["compiled"] is True

    def test_worker_triples(self, tmp_path):
        td = tmp_path / "worker_0" / "triples"
        _write_json(td / "t1.json", [_triple_dict(compiled=True)])
        td2 = tmp_path / "worker_1" / "triples"
        _write_json(td2 / "t2.json", [_triple_dict(compiled=False, compiler_output="err")])

        triples = load_triples(tmp_path)
        assert len(triples) == 2


# ---------------------------------------------------------------------------
# Tests: loading failure records
# ---------------------------------------------------------------------------

class TestLoadFailures:
    def test_load_failures(self, tmp_path):
        fd = tmp_path / "worker_0" / "failures"
        _write_json(fd / "t1.json", {
            "item_id": "T1",
            "cause": "hallucinated_identifier",
            "total_attempts": 15,
        })

        records = load_failure_records(tmp_path)
        assert len(records) == 1
        assert records[0]["cause"] == "hallucinated_identifier"


# ---------------------------------------------------------------------------
# Tests: error classification aggregation
# ---------------------------------------------------------------------------

class TestErrorAggregation:
    def test_error_category_counts(self, tmp_path):
        triples = [
            _triple_dict(
                compiled=False,
                compiler_output="file.lean:10:4: error: type mismatch\nfoo has type Nat",
            ),
            _triple_dict(
                compiled=False,
                compiler_output="file.lean:5:0: error: unsolved goals\ncase inl\n...",
            ),
            _triple_dict(
                compiled=False,
                compiler_output="file.lean:3:0: error: unknown identifier `Foo.bar`",
            ),
            _triple_dict(compiled=True, compiler_output=""),
        ]

        stats = DashboardStats([], triples, [], [], tmp_path)
        assert stats.error_category_counts["type_mismatch"] == 1
        assert stats.error_category_counts["tactic"] == 1
        assert stats.error_category_counts["missing_lemma"] == 1
        assert stats.total_errors == 3

    def test_hallucinated_identifiers(self, tmp_path):
        triples = [
            _triple_dict(
                compiled=False,
                compiler_output="file.lean:3:0: error: unknown identifier `Nat.fake_lemma`",
            ),
            _triple_dict(
                compiled=False,
                compiler_output="file.lean:5:0: error: unknown constant `Nat.fake_lemma`",
            ),
            _triple_dict(
                compiled=False,
                compiler_output="file.lean:7:0: error: unknown identifier `Real.bogus`",
            ),
        ]

        stats = DashboardStats([], triples, [], [], tmp_path)
        assert stats.hallucinated_identifiers["Nat.fake_lemma"] == 2
        assert stats.hallucinated_identifiers["Real.bogus"] == 1


# ---------------------------------------------------------------------------
# Tests: category breakdown
# ---------------------------------------------------------------------------

class TestCategoryBreakdown:
    def test_category_stats(self, tmp_path):
        entries = [
            BacklogEntry(item=_item("T1", section="Algebra"), category=ItemCategory.THEOREM,
                         status=BacklogStatus.COMPLETED, attempts=2),
            BacklogEntry(item=_item("T2", section="Algebra"), category=ItemCategory.THEOREM,
                         status=BacklogStatus.COMPLETED, attempts=5),
            BacklogEntry(item=_item("T3", section="Algebra"), category=ItemCategory.THEOREM,
                         status=BacklogStatus.FAILED, attempts=1,
                         failure_reason="type mismatch"),
            BacklogEntry(item=_item("T4", section="Topology"), category=ItemCategory.THEOREM,
                         status=BacklogStatus.COMPLETED, attempts=1),
            BacklogEntry(item=_item("T5", section="Topology"), category=ItemCategory.THEOREM,
                         status=BacklogStatus.FAILED, attempts=1,
                         failure_reason="unsolved goals"),
        ]

        stats = DashboardStats(entries, [], [], [], tmp_path)
        assert stats.category_stats["Algebra"]["completed"] == 2
        assert stats.category_stats["Algebra"]["failed"] == 1
        assert stats.category_stats["Algebra"]["attempted"] == 3
        assert stats.category_stats["Topology"]["completed"] == 1
        assert stats.category_stats["Topology"]["failed"] == 1


# ---------------------------------------------------------------------------
# Tests: status counts and success rate
# ---------------------------------------------------------------------------

class TestStatusCounts:
    def test_counts_and_rate(self, tmp_path):
        now = datetime.now()
        entries = [
            BacklogEntry(item=_item("T1"), category=ItemCategory.THEOREM,
                         status=BacklogStatus.COMPLETED, attempts=3,
                         completed_at=now),
            BacklogEntry(item=_item("T2"), category=ItemCategory.THEOREM,
                         status=BacklogStatus.COMPLETED, attempts=1,
                         completed_at=now),
            BacklogEntry(item=_item("T3"), category=ItemCategory.THEOREM,
                         status=BacklogStatus.FAILED, attempts=1,
                         failure_reason="err"),
            BacklogEntry(item=_item("T4"), category=ItemCategory.THEOREM,
                         status=BacklogStatus.READY, attempts=0),
        ]

        stats = DashboardStats(entries, [], [], [], tmp_path)
        assert stats.total == 4
        assert stats.completed == 2
        assert stats.failed == 1
        assert stats.ready == 1
        assert stats.attempted == 3  # completed + failed
        assert abs(stats.success_rate - 66.7) < 0.1

    def test_attempts_per_success(self, tmp_path):
        entries = [
            BacklogEntry(item=_item("T1"), category=ItemCategory.THEOREM,
                         status=BacklogStatus.COMPLETED, attempts=1),
            BacklogEntry(item=_item("T2"), category=ItemCategory.THEOREM,
                         status=BacklogStatus.COMPLETED, attempts=5),
            BacklogEntry(item=_item("T3"), category=ItemCategory.THEOREM,
                         status=BacklogStatus.COMPLETED, attempts=3),
        ]

        stats = DashboardStats(entries, [], [], [], tmp_path)
        assert stats.avg_attempts == 3.0
        assert stats.median_attempts == 3.0


# ---------------------------------------------------------------------------
# Tests: model performance
# ---------------------------------------------------------------------------

class TestModelPerformance:
    def test_model_counts(self, tmp_path):
        triples = [
            _triple_dict(compiled=False, model="deepseek/deepseek-reasoner",
                         compiler_output="err"),
            _triple_dict(compiled=True, model="deepseek/deepseek-reasoner"),
            _triple_dict(compiled=False, model="gemini/gemini-2.5-pro",
                         compiler_output="err"),
            _triple_dict(compiled=True, model="gemini/gemini-2.5-pro"),
            _triple_dict(compiled=True, model="gemini/gemini-2.5-pro"),
        ]

        stats = DashboardStats([], triples, [], [], tmp_path)
        assert stats.model_counts["deepseek/deepseek-reasoner"] == 2
        assert stats.model_counts["gemini/gemini-2.5-pro"] == 3
        assert stats.model_successes["deepseek/deepseek-reasoner"] == 1
        assert stats.model_successes["gemini/gemini-2.5-pro"] == 2


# ---------------------------------------------------------------------------
# Tests: failure cause breakdown
# ---------------------------------------------------------------------------

class TestResultsSummary:
    def test_load_results_summaries(self, tmp_path):
        _write_json(tmp_path / "worker_0" / "results_summary.json", {
            "total": 2, "successes": 1, "failures": 1,
            "items": [
                {"id": "T1", "success": True, "attempts": 5, "lean_file": "t1.lean", "error": None},
                {"id": "T2", "success": False, "attempts": 15, "lean_file": None, "error": "err"},
            ],
        })
        results = load_results_summaries(tmp_path)
        assert len(results) == 2
        assert results[0]["id"] == "T1"

    def test_attempts_from_results_summary(self, tmp_path):
        """Results summary provides more accurate attempt counts than backlog."""
        entries = [
            BacklogEntry(item=_item("T1"), category=ItemCategory.THEOREM,
                         status=BacklogStatus.COMPLETED, attempts=1),
            BacklogEntry(item=_item("T2"), category=ItemCategory.THEOREM,
                         status=BacklogStatus.COMPLETED, attempts=1),
        ]
        results = [
            {"id": "T1", "success": True, "attempts": 3},
            {"id": "T2", "success": True, "attempts": 7},
        ]

        stats = DashboardStats(entries, [], [], [], tmp_path,
                               results_summaries=results)
        # Should use results_summary attempts (3,7), not backlog attempts (1,1)
        assert stats.avg_attempts == 5.0
        assert stats.median_attempts == 5.0


class TestFailureCauses:
    def test_cause_counts(self, tmp_path):
        failures = [
            {"item_id": "T1", "cause": "hallucinated_identifier"},
            {"item_id": "T2", "cause": "compiler_error"},
            {"item_id": "T3", "cause": "hallucinated_identifier"},
        ]

        stats = DashboardStats([], [], failures, [], tmp_path)
        assert stats.failure_causes["hallucinated_identifier"] == 2
        assert stats.failure_causes["compiler_error"] == 1


# ---------------------------------------------------------------------------
# Tests: formatting
# ---------------------------------------------------------------------------

class TestFormatting:
    def test_format_empty(self, tmp_path):
        stats = DashboardStats([], [], [], [], tmp_path)
        output = format_dashboard(stats)
        assert "LeanKnowledge Pipeline Dashboard" in output
        assert "EMPTY" in output

    def test_format_with_data(self, tmp_path):
        now = datetime.now()
        entries = [
            BacklogEntry(item=_item("T1"), category=ItemCategory.THEOREM,
                         status=BacklogStatus.COMPLETED, attempts=2,
                         added_at=now - timedelta(hours=1),
                         completed_at=now),
            BacklogEntry(item=_item("T2"), category=ItemCategory.THEOREM,
                         status=BacklogStatus.FAILED, attempts=1,
                         added_at=now - timedelta(hours=1),
                         failure_reason="err"),
        ]
        triples = [
            _triple_dict(compiled=False,
                         compiler_output="file.lean:1:0: error: unsolved goals"),
            _triple_dict(compiled=True),
        ]

        stats = DashboardStats(entries, triples, [], [], tmp_path)
        output = format_dashboard(stats)
        assert "Proved:" in output
        assert "Failed:" in output
        assert "Error Breakdown" in output
        assert "tactic" in output  # unsolved goals -> TACTIC

    def test_format_in_progress(self, tmp_path):
        entries = [
            BacklogEntry(item=_item("T1"), category=ItemCategory.THEOREM,
                         status=BacklogStatus.IN_PROGRESS, attempts=1),
            BacklogEntry(item=_item("T2"), category=ItemCategory.THEOREM,
                         status=BacklogStatus.READY, attempts=0),
        ]

        stats = DashboardStats(entries, [], [], [], tmp_path)
        output = format_dashboard(stats)
        assert "IN PROGRESS" in output
        assert "In Progress:" in output


# ---------------------------------------------------------------------------
# Tests: end-to-end with file I/O
# ---------------------------------------------------------------------------

class TestEndToEnd:
    def test_full_run_dashboard(self, tmp_path):
        """Simulate a small run with backlog, triples, and failures."""
        now = datetime.now()
        now_iso = now.isoformat()
        earlier_iso = (now - timedelta(hours=2)).isoformat()

        # Backlog
        backlog = {
            "T1": _backlog_dict("T1", status="completed", attempts=2,
                                added_at=earlier_iso, completed_at=now_iso,
                                section="Number Theory"),
            "T2": _backlog_dict("T2", status="completed", attempts=5,
                                added_at=earlier_iso, completed_at=now_iso,
                                section="Number Theory"),
            "T3": _backlog_dict("T3", status="failed", attempts=1,
                                added_at=earlier_iso,
                                failure_reason="type mismatch",
                                section="Probability"),
            "T4": _backlog_dict("T4", status="ready", attempts=0,
                                added_at=earlier_iso,
                                section="Algebra"),
        }
        _write_json(tmp_path / "backlog.json", backlog)

        # Triples
        _write_json(tmp_path / "triples" / "t1.json", [
            _triple_dict(compiled=False,
                         compiler_output="file.lean:5:0: error: type mismatch"),
            _triple_dict(compiled=True),
        ])
        _write_json(tmp_path / "triples" / "t3.json", [
            _triple_dict(compiled=False,
                         compiler_output="file.lean:3:0: error: unknown identifier `Nat.fake`"),
        ])

        # Failures
        _write_json(tmp_path / "failures" / "t3.json", {
            "item_id": "T3", "cause": "hallucinated_identifier", "total_attempts": 15,
        })

        output = run_dashboard(tmp_path)

        # Check key statistics appear
        assert "3/4" in output  # 3 attempted out of 4
        assert "Proved:" in output
        assert "Failed:" in output
        assert "Remaining:" in output
        assert "Error Breakdown" in output
        assert "Failure Causes" in output
        assert "hallucinated_identifier" in output

    def test_worker_layout_full(self, tmp_path):
        """Worker-based layout with multiple workers."""
        now = datetime.now()
        now_iso = now.isoformat()
        earlier_iso = (now - timedelta(hours=1)).isoformat()

        w0 = tmp_path / "worker_0"
        w1 = tmp_path / "worker_1"

        _write_json(w0 / "backlog.json", {
            "T1": _backlog_dict("T1", status="completed", attempts=1,
                                added_at=earlier_iso, completed_at=now_iso),
        })
        _write_json(w1 / "backlog.json", {
            "T2": _backlog_dict("T2", status="failed", attempts=1,
                                added_at=earlier_iso,
                                failure_reason="unsolved goals"),
        })

        _write_json(w0 / "triples" / "t1.json", [
            _triple_dict(compiled=True, model="deepseek/deepseek-reasoner"),
        ])
        _write_json(w1 / "triples" / "t2.json", [
            _triple_dict(compiled=False, model="gemini/gemini-2.5-pro",
                         compiler_output="file.lean:5:0: error: unsolved goals"),
        ])

        output = run_dashboard(tmp_path)
        assert "2/2" in output
        assert "Model Performance" in output
        assert "deepseek/deepseek-reasoner" in output
        assert "gemini/gemini-2.5-pro" in output
