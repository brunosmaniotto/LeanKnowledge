"""Tests for the Prompt Tuner."""

import json
import pytest

from leanknowledge.prompt_tuner import (
    PromptTuner,
    Rule,
    STATIC_RULES,
    _extract_patterns,
)


# ---------------------------------------------------------------------------
# Static rules
# ---------------------------------------------------------------------------

class TestStaticRules:
    def test_has_rules(self):
        assert len(STATIC_RULES) > 5

    def test_general_rule_always_included(self):
        tuner = PromptTuner()
        lessons = tuner.get_lessons()
        assert "import Mathlib" in lessons

    def test_lean3_syntax_rule_matches(self):
        tuner = PromptTuner()
        errors = ["unexpected token 'in'; expected ','"]
        lessons = tuner.get_lessons(errors)
        assert "Lean 3" in lessons or "NEVER use Lean 3" in lessons

    def test_nat_division_rule_matches(self):
        tuner = PromptTuner()
        errors = ["rewrite failed: Did not find pattern / in expression"]
        lessons = tuner.get_lessons(errors)
        assert "floor" in lessons.lower() or "FLOOR" in lessons

    def test_hallucinated_ident_rule_matches(self):
        tuner = PromptTuner()
        errors = ["Unknown constant `Rat.coprime_num_den`"]
        lessons = tuner.get_lessons(errors)
        assert "guess" in lessons.lower() or "NOT guess" in lessons

    def test_empty_code_rule_matches(self):
        tuner = PromptTuner()
        errors = ["empty or vacuous code"]
        lessons = tuner.get_lessons(errors)
        assert "theorem" in lessons.lower()


# ---------------------------------------------------------------------------
# Dynamic pattern extraction
# ---------------------------------------------------------------------------

class TestPatternExtraction:
    def test_no_triples(self):
        patterns = _extract_patterns([])
        assert patterns == []

    def test_all_success(self):
        triples = [{"compiled": True, "compiler_output": "", "lean_code": "ok"}]
        patterns = _extract_patterns(triples)
        assert patterns == []

    def test_single_error_not_pattern(self):
        """A single error doesn't count as a pattern."""
        triples = [
            {"compiled": False, "compiler_output": "error: foo", "lean_code": "bad"},
        ]
        patterns = _extract_patterns(triples)
        assert len(patterns) == 0

    def test_repeated_error_is_pattern(self):
        triples = [
            {"compiled": False, "compiler_output": "/a.lean:1:0: error: unknown id X", "lean_code": "bad1"},
            {"compiled": False, "compiler_output": "/b.lean:5:2: error: unknown id X", "lean_code": "bad2"},
        ]
        patterns = _extract_patterns(triples)
        assert len(patterns) == 1
        assert patterns[0].count == 2

    def test_different_errors_separate(self):
        triples = [
            {"compiled": False, "compiler_output": "/a.lean:1:0: error: unknown X", "lean_code": ""},
            {"compiled": False, "compiler_output": "/a.lean:1:0: error: type mismatch", "lean_code": ""},
        ]
        patterns = _extract_patterns(triples)
        # Both appear only once, so neither is a pattern
        assert len(patterns) == 0


# ---------------------------------------------------------------------------
# Tuner ingestion
# ---------------------------------------------------------------------------

class TestTunerIngestion:
    def test_ingest_triples(self):
        tuner = PromptTuner()
        triples = [
            {"compiled": False, "compiler_output": "unexpected token 'in'", "lean_code": "bad"},
            {"compiled": True, "compiler_output": "", "lean_code": "good"},
        ]
        tuner.ingest_triples(triples)

        assert tuner.stats["total_failures_ingested"] == 1
        assert "lean3_sum_syntax" in tuner.stats["triggered_rules"]

    def test_ingested_rules_boost(self):
        tuner = PromptTuner()
        triples = [
            {"compiled": False, "compiler_output": "unexpected token 'in'", "lean_code": ""},
            {"compiled": False, "compiler_output": "unexpected token 'in'", "lean_code": ""},
        ]
        tuner.ingest_triples(triples)

        # The lean3 rule should appear in lessons even without current errors
        lessons = tuner.get_lessons()
        assert "Lean 3" in lessons or "NEVER" in lessons

    def test_ingest_from_dir(self, tmp_path):
        triples_dir = tmp_path / "triples"
        triples_dir.mkdir()
        data = [
            {"compiled": False, "compiler_output": "Unknown constant `foo`", "lean_code": "bad"},
            {"compiled": False, "compiler_output": "Unknown constant `bar`", "lean_code": "bad"},
        ]
        (triples_dir / "test_001.json").write_text(json.dumps(data))

        tuner = PromptTuner()
        tuner.ingest_triples_dir(triples_dir)

        assert tuner.stats["total_failures_ingested"] == 2
        assert "hallucinated_ident" in tuner.stats["triggered_rules"]

    def test_ingest_nonexistent_dir(self, tmp_path):
        tuner = PromptTuner()
        tuner.ingest_triples_dir(tmp_path / "nope")
        assert tuner.stats["total_failures_ingested"] == 0


# ---------------------------------------------------------------------------
# Lessons output
# ---------------------------------------------------------------------------

class TestLessonsOutput:
    def test_lessons_not_empty(self):
        tuner = PromptTuner()
        lessons = tuner.get_lessons()
        assert len(lessons) > 100  # should be a substantial block of text

    def test_lessons_with_current_errors_prioritizes(self):
        tuner = PromptTuner()
        lessons = tuner.get_lessons(["Unknown identifier `Foo`"])
        # Should include hallucinated ident rule
        assert "NOT guess" in lessons or "exact?" in lessons

    def test_recurring_errors_section(self):
        tuner = PromptTuner()
        triples = [
            {"compiled": False, "compiler_output": "/a.lean:1:0: error: same thing", "lean_code": ""},
            {"compiled": False, "compiler_output": "/b.lean:2:0: error: same thing", "lean_code": ""},
            {"compiled": False, "compiler_output": "/c.lean:3:0: error: same thing", "lean_code": ""},
        ]
        tuner.ingest_triples(triples)
        lessons = tuner.get_lessons()
        assert "Recurring errors" in lessons
        assert "3" in lessons  # should show count
