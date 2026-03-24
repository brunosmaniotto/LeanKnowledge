"""Tests for Agent 7: Supervisor — run analysis and error pattern detection."""

import json
import pytest
from datetime import datetime
from pathlib import Path

from leanknowledge.agents.supervisor import (
    Supervisor,
    RunReport,
    RunSummary,
    ErrorBreakdown,
    IdentifierAnalysis,
    FailureAnalysis,
    Recommendation,
    WorkerStats,
    _normalize_error_message,
    _find_nearest_identifier,
    _root_cause_from_category,
)


# ---------------------------------------------------------------------------
# Fixtures — build realistic run directories
# ---------------------------------------------------------------------------

def _make_triple(
    theorem_id: str,
    compiled: bool,
    compiler_output: str = "",
    lean_code: str = "",
    model: str = "deepseek/deepseek-reasoner",
    attempt: int = 1,
) -> dict:
    """Create a triple dict matching the format saved by pipeline.py."""
    return {
        "structured_proof": {
            "theorem_name": theorem_id,
            "strategy": "direct",
            "goal_statement": f"Prove {theorem_id}",
            "assumptions": [],
            "dependencies": [],
            "steps": [],
            "conclusion": "QED",
        },
        "lean_code": lean_code,
        "compiler_output": compiler_output,
        "compiled": compiled,
        "model": model,
        "attempt_number": attempt,
        "reasoning": "",
    }


def _make_single_worker_run(tmp_path: Path) -> Path:
    """Create a single-worker run directory with triples."""
    run_dir = tmp_path / "run_test"
    triples_dir = run_dir / "triples"
    lean_dir = run_dir / "lean"
    triples_dir.mkdir(parents=True)
    lean_dir.mkdir(parents=True)

    # Theorem 1: success on 2nd attempt
    triples1 = [
        _make_triple(
            "sum_of_squares", False,
            compiler_output="/tmp/Scratch.lean:5:4: error: unknown identifier 'Nat.sum_squares'",
            lean_code="theorem sum_of_squares : sorry := by\n  exact Nat.sum_squares",
            attempt=1,
        ),
        _make_triple(
            "sum_of_squares", True,
            compiler_output="",
            lean_code="import Mathlib\ntheorem sum_of_squares (n : Nat) : True := trivial",
            attempt=2,
        ),
    ]
    (triples_dir / "sum_of_squares_20260308_120000.json").write_text(
        json.dumps(triples1)
    )
    (lean_dir / "sum_of_squares.lean").write_text("-- success")

    # Theorem 2: failed all 3 attempts
    triples2 = [
        _make_triple(
            "law_of_cosines", False,
            compiler_output="/tmp/Scratch.lean:10:0: error: unknown constant 'Real.cos_add'",
            lean_code="import Mathlib\ntheorem law_of_cosines := by exact Real.cos_add",
            attempt=1,
        ),
        _make_triple(
            "law_of_cosines", False,
            compiler_output="/tmp/Scratch.lean:8:4: error: tactic 'simp' failed, no progress",
            lean_code="import Mathlib\ntheorem law_of_cosines := by simp",
            attempt=2,
        ),
        _make_triple(
            "law_of_cosines", False,
            compiler_output="/tmp/Scratch.lean:12:2: error: type mismatch\n  has type Real\n  expected type Nat",
            lean_code="import Mathlib\ntheorem law_of_cosines := by norm_num",
            attempt=3,
        ),
    ]
    (triples_dir / "law_of_cosines_20260308_120100.json").write_text(
        json.dumps(triples2)
    )

    # Theorem 3: failed with missing lemma
    triples3 = [
        _make_triple(
            "triangular_number", False,
            compiler_output="/tmp/Scratch.lean:3:4: error: unknown constant 'Nat.triangular_formula'",
            lean_code="import Mathlib\ntheorem tri := Nat.triangular_formula",
            attempt=1,
        ),
    ]
    (triples_dir / "triangular_number_20260308_120200.json").write_text(
        json.dumps(triples3)
    )

    # Confirmed identifiers
    confirmed = {"Nat.add_comm": 5, "Real.cos_sq_add_sin_sq": 2, "Nat.Prime.pos": 3}
    (run_dir / "confirmed_identifiers.json").write_text(json.dumps(confirmed))

    return run_dir


def _make_parallel_run(tmp_path: Path) -> Path:
    """Create a multi-worker parallel run directory."""
    run_dir = tmp_path / "run_parallel"
    run_dir.mkdir(parents=True)

    for w in range(2):
        worker_dir = run_dir / f"worker_{w}"
        triples_dir = worker_dir / "triples"
        triples_dir.mkdir(parents=True)

        if w == 0:
            # Worker 0: 1 success, 1 failure
            t1 = [_make_triple("thm_a", True, lean_code="theorem a := trivial")]
            (triples_dir / "thm_a_20260308_130000.json").write_text(json.dumps(t1))

            t2 = [_make_triple(
                "thm_b", False,
                compiler_output="/tmp/Scratch.lean:1:0: error: unknown identifier 'Foo.bar'",
                lean_code="bad code",
            )]
            (triples_dir / "thm_b_20260308_130100.json").write_text(json.dumps(t2))

            cid = {"Nat.succ_pos": 1}
            (worker_dir / "confirmed_identifiers.json").write_text(json.dumps(cid))
        else:
            # Worker 1: 2 successes
            t1 = [_make_triple("thm_c", True, lean_code="theorem c := trivial")]
            (triples_dir / "thm_c_20260308_131000.json").write_text(json.dumps(t1))

            t2 = [_make_triple(
                "thm_d", True,
                lean_code="import Mathlib\ntheorem d : 1 + 1 = 2 := by norm_num",
            )]
            (triples_dir / "thm_d_20260308_131100.json").write_text(json.dumps(t2))

            cid = {"Nat.add_zero": 2}
            (worker_dir / "confirmed_identifiers.json").write_text(json.dumps(cid))

        # Write a log file
        log_content = f"Worker {w} log\n=== SUCCESS thm_x ===\n"
        if w == 0:
            log_content += "=== FAILED thm_b ===\n"
        (run_dir / f"worker_{w}.log").write_text(log_content)

    # Merged confirmed identifiers
    merged = {"Nat.succ_pos": 1, "Nat.add_zero": 2}
    (run_dir / "confirmed_identifiers.json").write_text(json.dumps(merged))

    return run_dir


# ---------------------------------------------------------------------------
# Helper function tests
# ---------------------------------------------------------------------------

class TestNormalizeErrorMessage:
    def test_strips_file_path(self):
        msg = "/tmp/Scratch.lean:10:4: error: unknown identifier 'foo'"
        result = _normalize_error_message(msg)
        assert "Scratch.lean" not in result
        assert "<IDENT>" in result

    def test_first_line_only(self):
        msg = "error: first line\nsecond line\nthird line"
        result = _normalize_error_message(msg)
        assert "second" not in result

    def test_normalizes_identifiers(self):
        msg = "unknown constant 'Nat.foo_bar'"
        result = _normalize_error_message(msg)
        assert "Nat.foo_bar" not in result
        assert "<IDENT>" in result

    def test_truncates_long_messages(self):
        msg = "x" * 200
        result = _normalize_error_message(msg)
        assert len(result) <= 120


class TestFindNearestIdentifier:
    def test_no_confirmed(self):
        assert _find_nearest_identifier("Nat.foo", set()) is None

    def test_same_namespace_close_leaf(self):
        confirmed = {"Nat.add_comm", "Nat.add_assoc", "Real.cos"}
        result = _find_nearest_identifier("Nat.add_com", confirmed)
        assert result == "Nat.add_comm"

    def test_different_namespace_no_match(self):
        confirmed = {"Real.cos", "Real.sin"}
        result = _find_nearest_identifier("Nat.add_comm", confirmed)
        assert result is None

    def test_partial_namespace_overlap(self):
        confirmed = {"Finset.sum_range_id", "Finset.prod_range"}
        result = _find_nearest_identifier("Finset.sum_range", confirmed)
        assert result == "Finset.sum_range_id"

    def test_single_part_identifier_skipped(self):
        confirmed = {"omega"}
        result = _find_nearest_identifier("omega", confirmed)
        assert result is None


class TestRootCauseFromCategory:
    def test_syntax_unknown_id(self):
        rc = _root_cause_from_category("syntax", "unknown identifier 'X'")
        assert "hallucinated" in rc.lower() or "identifier" in rc.lower()

    def test_syntax_unexpected_token(self):
        rc = _root_cause_from_category("syntax", "unexpected token 'in'")
        assert "lean 3" in rc.lower()

    def test_tactic_unsolved(self):
        rc = _root_cause_from_category("tactic", "unsolved goals")
        assert "unsolved" in rc.lower()

    def test_type_mismatch(self):
        rc = _root_cause_from_category("type_mismatch", "type mismatch nat int")
        assert "coercion" in rc.lower() or "type" in rc.lower()

    def test_missing_lemma(self):
        rc = _root_cause_from_category("missing_lemma", "unknown constant X")
        assert "lemma" in rc.lower() or "exist" in rc.lower()

    def test_unknown(self):
        rc = _root_cause_from_category("other_category", "something")
        assert "unclassified" in rc.lower()


# ---------------------------------------------------------------------------
# Supervisor — single-worker run
# ---------------------------------------------------------------------------

class TestSupervisorSingleWorker:
    def test_analyze_returns_report(self, tmp_path):
        run_dir = _make_single_worker_run(tmp_path)
        supervisor = Supervisor(run_dir)
        report = supervisor.analyze(use_llm=False)

        assert isinstance(report, RunReport)
        assert report.run_dir == str(run_dir)
        assert report.timestamp  # non-empty

    def test_phase1_summary(self, tmp_path):
        run_dir = _make_single_worker_run(tmp_path)
        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        s = report.summary
        assert s.total_theorems == 3
        assert s.successes == 1
        assert s.failures == 2
        assert s.total_attempts == 6  # 2 + 3 + 1
        assert 0 < s.success_rate < 1

    def test_phase1_avg_attempts(self, tmp_path):
        run_dir = _make_single_worker_run(tmp_path)
        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        s = report.summary
        # Only sum_of_squares succeeded with 2 attempts
        assert s.avg_attempts_per_success == 2.0
        assert s.avg_attempts_per_theorem == 2.0  # 6 / 3

    def test_phase2_error_categories(self, tmp_path):
        run_dir = _make_single_worker_run(tmp_path)
        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        e = report.error_breakdown
        assert e.total_error_instances > 0
        # We have: syntax (unknown identifier), missing_lemma (unknown constant),
        # tactic, and type_mismatch errors
        assert len(e.category_counts) >= 2

    def test_phase2_top_errors(self, tmp_path):
        run_dir = _make_single_worker_run(tmp_path)
        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        e = report.error_breakdown
        assert len(e.top_errors) > 0
        # All buckets should have count >= 1
        for bucket in e.top_errors:
            assert bucket.count >= 1
            assert bucket.category
            assert bucket.normalized_message

    def test_phase3_hallucinated_identifiers(self, tmp_path):
        run_dir = _make_single_worker_run(tmp_path)
        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        ident = report.identifier_analysis
        # We have: Nat.sum_squares, Real.cos_add, Nat.triangular_formula, Foo.bar-like
        assert ident.total_hallucinated >= 2
        assert ident.unique_hallucinated >= 2

        # Check specific hallucinated identifiers
        hallucinated_names = [h for h, _ in ident.top_hallucinated]
        assert "Nat.sum_squares" in hallucinated_names or \
               "Nat.triangular_formula" in hallucinated_names

    def test_phase3_confirmed_identifiers(self, tmp_path):
        run_dir = _make_single_worker_run(tmp_path)
        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        ident = report.identifier_analysis
        assert ident.unique_confirmed > 0
        # From confirmed_identifiers.json + successful lean code
        confirmed_names = [c for c, _ in ident.top_confirmed]
        assert "Nat.add_comm" in confirmed_names or \
               "Nat.Prime.pos" in confirmed_names

    def test_phase4_failure_analysis(self, tmp_path):
        run_dir = _make_single_worker_run(tmp_path)
        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        assert len(report.failure_analysis) == 2  # law_of_cosines, triangular_number
        for fa in report.failure_analysis:
            assert fa.theorem_id
            assert fa.num_attempts > 0
            assert fa.root_cause  # non-empty
            assert fa.error_categories  # non-empty

    def test_phase5_recommendations(self, tmp_path):
        run_dir = _make_single_worker_run(tmp_path)
        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        recs = report.recommendations
        assert len(recs) > 0
        # All recommendations should have ranks
        for rec in recs:
            assert rec.rank > 0
            assert rec.title
            assert rec.description
            assert rec.estimated_impact_pct >= 0

        # Ranks should be sequential
        ranks = [r.rank for r in recs]
        assert ranks == list(range(1, len(recs) + 1))


# ---------------------------------------------------------------------------
# Supervisor — parallel (multi-worker) run
# ---------------------------------------------------------------------------

class TestSupervisorParallelRun:
    def test_discovers_workers(self, tmp_path):
        run_dir = _make_parallel_run(tmp_path)
        supervisor = Supervisor(run_dir)
        workers = supervisor._discover_workers()
        assert len(workers) == 2

    def test_summary_across_workers(self, tmp_path):
        run_dir = _make_parallel_run(tmp_path)
        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        s = report.summary
        assert s.total_theorems == 4
        assert s.successes == 3
        assert s.failures == 1

    def test_per_worker_stats(self, tmp_path):
        run_dir = _make_parallel_run(tmp_path)
        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        assert len(report.summary.workers) == 2

    def test_merged_identifiers(self, tmp_path):
        run_dir = _make_parallel_run(tmp_path)
        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        ident = report.identifier_analysis
        confirmed_names = [c for c, _ in ident.top_confirmed]
        # Should have merged both worker identifiers
        assert "Nat.succ_pos" in confirmed_names or "Nat.add_zero" in confirmed_names

    def test_loads_logs(self, tmp_path):
        run_dir = _make_parallel_run(tmp_path)
        supervisor = Supervisor(run_dir)
        supervisor._worker_dirs = supervisor._discover_workers()
        logs = supervisor._load_logs()
        assert len(logs) == 2


# ---------------------------------------------------------------------------
# Edge cases
# ---------------------------------------------------------------------------

class TestSupervisorEdgeCases:
    def test_empty_run_dir(self, tmp_path):
        """Supervisor handles an empty directory gracefully."""
        run_dir = tmp_path / "empty_run"
        run_dir.mkdir()

        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        assert report.summary.total_theorems == 0
        assert report.summary.successes == 0
        assert len(report.error_breakdown.top_errors) == 0
        assert len(report.failure_analysis) == 0

    def test_malformed_json_skipped(self, tmp_path):
        """Malformed triple files are skipped without crashing."""
        run_dir = tmp_path / "bad_run"
        triples_dir = run_dir / "triples"
        triples_dir.mkdir(parents=True)

        # Write malformed JSON
        (triples_dir / "bad_20260308_120000.json").write_text("{not valid json")
        # Write valid JSON
        valid = [_make_triple("good_thm", True, lean_code="theorem g := trivial")]
        (triples_dir / "good_thm_20260308_120100.json").write_text(json.dumps(valid))

        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        assert report.summary.total_theorems == 1
        assert report.summary.successes == 1

    def test_all_success_run(self, tmp_path):
        """Run where everything succeeds produces a valid report."""
        run_dir = tmp_path / "perfect_run"
        triples_dir = run_dir / "triples"
        triples_dir.mkdir(parents=True)

        for i in range(5):
            t = [_make_triple(f"thm_{i}", True, lean_code=f"theorem t{i} := trivial")]
            (triples_dir / f"thm_{i}_20260308_12000{i}.json").write_text(json.dumps(t))

        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        assert report.summary.successes == 5
        assert report.summary.failures == 0
        assert report.summary.success_rate == 1.0
        assert len(report.failure_analysis) == 0
        assert report.error_breakdown.total_error_instances == 0

    def test_all_failure_run(self, tmp_path):
        """Run where everything fails produces a valid report with recommendations."""
        run_dir = tmp_path / "failed_run"
        triples_dir = run_dir / "triples"
        triples_dir.mkdir(parents=True)

        for i in range(5):
            t = [_make_triple(
                f"hard_thm_{i}", False,
                compiler_output=f"/tmp/Scratch.lean:1:0: error: unknown constant 'Fake.lemma_{i}'",
                lean_code=f"theorem h{i} := Fake.lemma_{i}",
            )]
            (triples_dir / f"hard_thm_{i}_20260308_12000{i}.json").write_text(json.dumps(t))

        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        assert report.summary.successes == 0
        assert report.summary.failures == 5
        assert report.summary.success_rate == 0.0
        assert len(report.failure_analysis) == 5
        assert report.error_breakdown.total_error_instances > 0

    def test_empty_compiler_output(self, tmp_path):
        """Triples with empty compiler output don't crash error classification."""
        run_dir = tmp_path / "empty_output"
        triples_dir = run_dir / "triples"
        triples_dir.mkdir(parents=True)

        t = [_make_triple("thm_empty", False, compiler_output="", lean_code="")]
        (triples_dir / "thm_empty_20260308_120000.json").write_text(json.dumps(t))

        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        assert report.summary.failures == 1


# ---------------------------------------------------------------------------
# Report output
# ---------------------------------------------------------------------------

class TestReportOutput:
    def test_save_report_json(self, tmp_path):
        run_dir = _make_single_worker_run(tmp_path)
        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        output_path = tmp_path / "report.json"
        supervisor.save_report(report, output_path)

        assert output_path.exists()
        data = json.loads(output_path.read_text())
        assert "summary" in data
        assert "error_breakdown" in data
        assert "identifier_analysis" in data
        assert "failure_analysis" in data
        assert "recommendations" in data

    def test_save_report_markdown(self, tmp_path):
        run_dir = _make_single_worker_run(tmp_path)
        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        output_path = tmp_path / "report.json"
        supervisor.save_report(report, output_path)

        md_path = tmp_path / "report.md"
        assert md_path.exists()
        md_text = md_path.read_text()
        assert "# Supervisor Report" in md_text
        assert "Phase 1" in md_text
        assert "Phase 2" in md_text

    def test_print_report_no_crash(self, tmp_path, capsys):
        """print_report runs without exception."""
        run_dir = _make_single_worker_run(tmp_path)
        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        supervisor.print_report(report)
        captured = capsys.readouterr()
        assert "SUPERVISOR REPORT" in captured.out
        assert "Phase 1" in captured.out

    def test_to_dict_round_trip(self, tmp_path):
        run_dir = _make_single_worker_run(tmp_path)
        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        d = report.to_dict()
        assert isinstance(d, dict)
        # Should be JSON-serializable
        json_str = json.dumps(d, default=str)
        assert len(json_str) > 100

    def test_save_default_path(self, tmp_path):
        """save_report with no path uses run_dir/supervisor_report.json."""
        run_dir = _make_single_worker_run(tmp_path)
        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        supervisor.save_report(report)  # no path

        assert (run_dir / "supervisor_report.json").exists()
        assert (run_dir / "supervisor_report.md").exists()


# ---------------------------------------------------------------------------
# Error bucket deduplication
# ---------------------------------------------------------------------------

class TestErrorBuckets:
    def test_same_error_different_theorems_grouped(self, tmp_path):
        """Same normalized error across theorems should be grouped."""
        run_dir = tmp_path / "grouped_run"
        triples_dir = run_dir / "triples"
        triples_dir.mkdir(parents=True)

        # Two theorems with the same error
        for name in ["thm_x", "thm_y"]:
            t = [_make_triple(
                name, False,
                compiler_output=f"/tmp/Scratch.lean:5:0: error: unknown identifier 'Nat.fake_lemma'",
                lean_code="bad",
            )]
            (triples_dir / f"{name}_20260308_120000.json").write_text(json.dumps(t))

        supervisor = Supervisor(run_dir)
        report = supervisor.analyze()

        # Should have one bucket with count=2 and both theorems
        matching = [
            b for b in report.error_breakdown.top_errors
            if "unknown identifier" in b.normalized_message.lower()
        ]
        assert len(matching) >= 1
        bucket = matching[0]
        assert bucket.count == 2
        assert len(bucket.affected_theorems) == 2
