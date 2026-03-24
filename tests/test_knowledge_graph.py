"""Tests for Agent 7: Knowledge Graph + Strategy Knowledge Base."""

import json
import pytest

from leanknowledge.knowledge_graph import (
    ProofProfile,
    StrategyKB,
    StrategyRecommendation,
    DomainStats,
    extract_proof_profile,
    build_from_rosetta,
    _extract_tactics,
    _extract_mathlib_lemmas,
    _extract_math_objects,
    _classify_proof_structure,
    _extract_keywords,
    _infer_domain,
)


# ---------------------------------------------------------------------------
# Sample Lean code for testing
# ---------------------------------------------------------------------------

SIMPLE_PROOF = """\
import Mathlib
open Finset BigOperators

theorem sum_first_n (n : ℕ) : 2 * ∑ i ∈ Finset.range (n + 1), i = n * (n + 1) := by
  induction n with
  | zero => simp
  | succ k ih =>
    rw [Finset.sum_range_succ]
    ring_nf
    omega
"""

CONTRADICTION_PROOF = """\
import Mathlib

theorem sqrt2_irrational : Irrational (Real.sqrt 2) := by
  by_contra h
  push_neg at h
  obtain ⟨q, hq⟩ := h
  have : q * q = 2 := by nlinarith [Real.sq_sqrt (by norm_num : (2:ℝ) ≥ 0)]
  exact absurd this (by norm_num)
"""

CASES_PROOF = """\
import Mathlib

theorem even_or_odd (n : ℕ) : Even n ∨ Odd n := by
  rcases Nat.even_or_odd n with h | h
  · exact Or.inl h
  · exact Or.inr h
"""

CALC_PROOF = """\
import Mathlib
open Finset BigOperators

theorem calc_example (a b : ℝ) (ha : a > 0) (hb : b > 0) : a + b ≥ 2 * Real.sqrt (a * b) := by
  have h := sq_nonneg (Real.sqrt a - Real.sqrt b)
  calc a + b = Real.sqrt a ^ 2 + Real.sqrt b ^ 2 := by
        rw [Real.sq_sqrt ha.le, Real.sq_sqrt hb.le]
    _ ≥ 2 * (Real.sqrt a * Real.sqrt b) := by nlinarith
    _ = 2 * Real.sqrt (a * b) := by rw [Real.sqrt_mul ha.le]
"""

DIRECT_PROOF = """\
import Mathlib

theorem nat_add_comm (a b : ℕ) : a + b = b + a := by
  ring
"""

EMPTY_PROOF = ""

MINIMAL_PROOF = """\
import Mathlib

theorem trivial_true : True := trivial
"""


# ---------------------------------------------------------------------------
# extract_proof_profile tests
# ---------------------------------------------------------------------------

class TestExtractProofProfile:
    def test_extract_tactics_simple(self):
        tactics = _extract_tactics(SIMPLE_PROOF)
        assert "induction" in tactics
        assert "simp" in tactics
        assert "omega" in tactics

    def test_extract_tactics_contradiction(self):
        tactics = _extract_tactics(CONTRADICTION_PROOF)
        assert "by_contra" in tactics
        assert "push_neg" in tactics
        assert "nlinarith" in tactics

    def test_extract_tactics_empty(self):
        tactics = _extract_tactics("")
        assert tactics == []

    def test_extract_mathlib_lemmas(self):
        lemmas = _extract_mathlib_lemmas(SIMPLE_PROOF)
        assert "Finset.sum_range_succ" in lemmas
        assert "Finset.range" in lemmas

    def test_extract_mathlib_lemmas_filters_imports(self):
        code = "import Mathlib.Data.Nat.Basic\ntheorem foo : True := trivial"
        lemmas = _extract_mathlib_lemmas(code)
        # Mathlib.Data.Nat.Basic should be filtered (import path)
        assert not any(l.startswith("Mathlib.") for l in lemmas)

    def test_extract_mathlib_lemmas_empty(self):
        lemmas = _extract_mathlib_lemmas("")
        assert lemmas == []

    def test_classify_proof_structure_induction(self):
        assert _classify_proof_structure(SIMPLE_PROOF) == "induction"

    def test_classify_proof_structure_contradiction(self):
        assert _classify_proof_structure(CONTRADICTION_PROOF) == "contradiction"

    def test_classify_proof_structure_cases(self):
        assert _classify_proof_structure(CASES_PROOF) == "cases"

    def test_classify_proof_structure_calc(self):
        assert _classify_proof_structure(CALC_PROOF) == "calc_chain"

    def test_classify_proof_structure_direct(self):
        assert _classify_proof_structure(DIRECT_PROOF) == "direct"

    def test_classify_proof_structure_empty(self):
        assert _classify_proof_structure("") == "direct"

    def test_extract_math_objects(self):
        objects = _extract_math_objects(SIMPLE_PROOF)
        assert "Finset.range" in objects or "Finset.sum" in objects or "Finset" in objects
        # Should detect ℕ
        assert "\u2115" in objects  # ℕ

    def test_extract_math_objects_real(self):
        objects = _extract_math_objects(CALC_PROOF)
        assert "\u211d" in objects  # ℝ
        assert "Real.sqrt" in objects

    def test_extract_math_objects_empty(self):
        objects = _extract_math_objects("")
        assert objects == []

    def test_full_profile_extraction(self):
        profile = extract_proof_profile(
            lean_code=SIMPLE_PROOF,
            theorem_id="sum_first_n",
            domain="number_theory",
        )
        assert profile.theorem_id == "sum_first_n"
        assert profile.domain == "number_theory"
        assert "induction" in profile.tactics_used
        assert profile.proof_structure == "induction"
        assert profile.difficulty == 1  # no triples
        assert len(profile.mathematical_objects) > 0

    def test_profile_with_triples(self):
        triples = [
            {"compiled": False, "compiler_output": "unknown constant `Foo`",
             "lean_code": "bad", "model": "deepseek/deepseek-reasoner",
             "attempt_number": 1},
            {"compiled": False, "compiler_output": "type mismatch",
             "lean_code": "bad2", "model": "deepseek/deepseek-reasoner",
             "attempt_number": 2},
            {"compiled": True, "compiler_output": "",
             "lean_code": SIMPLE_PROOF, "model": "gemini/gemini-2.5-pro",
             "attempt_number": 3},
        ]
        profile = extract_proof_profile(
            lean_code=SIMPLE_PROOF,
            theorem_id="test_theorem",
            triples=triples,
        )
        assert profile.difficulty == 3
        assert profile.winning_model == "gemini/gemini-2.5-pro"
        assert profile.winning_tier == "direct"  # attempt 3 <= 3
        assert "missing_lemma" in profile.error_types_encountered  # "unknown constant"
        assert "type_mismatch" in profile.error_types_encountered

    def test_profile_tier_classification(self):
        """Test tier classification based on attempt number."""
        # Tier 1 (attempts 4-10)
        triples_t1 = [
            {"compiled": False, "compiler_output": "err", "lean_code": "bad",
             "model": "m", "attempt_number": i}
            for i in range(1, 8)
        ] + [
            {"compiled": True, "compiler_output": "", "lean_code": SIMPLE_PROOF,
             "model": "deepseek/deepseek-reasoner", "attempt_number": 8},
        ]
        profile = extract_proof_profile(SIMPLE_PROOF, triples=triples_t1)
        assert profile.winning_tier == "tier1"

        # Tier 2 (attempts 11-15)
        triples_t2 = [
            {"compiled": False, "compiler_output": "err", "lean_code": "bad",
             "model": "m", "attempt_number": i}
            for i in range(1, 13)
        ] + [
            {"compiled": True, "compiler_output": "", "lean_code": SIMPLE_PROOF,
             "model": "gemini/gemini-2.5-pro", "attempt_number": 13},
        ]
        profile = extract_proof_profile(SIMPLE_PROOF, triples=triples_t2)
        assert profile.winning_tier == "tier2"

    def test_empty_code_graceful(self):
        profile = extract_proof_profile(lean_code="", theorem_id="empty")
        assert profile.tactics_used == []
        assert profile.mathlib_lemmas == []
        assert profile.mathematical_objects == []
        assert profile.proof_structure == "direct"
        assert profile.difficulty == 1

    def test_minimal_code(self):
        profile = extract_proof_profile(lean_code=MINIMAL_PROOF)
        assert profile.proof_structure == "direct"


# ---------------------------------------------------------------------------
# StrategyKB tests
# ---------------------------------------------------------------------------

def _make_profile(
    theorem_id: str = "test",
    domain: str = "number_theory",
    tactics: list[str] | None = None,
    lemmas: list[str] | None = None,
    structure: str = "induction",
    difficulty: int = 3,
    objects: list[str] | None = None,
    errors: list[str] | None = None,
) -> ProofProfile:
    """Helper to create a ProofProfile with defaults."""
    return ProofProfile(
        theorem_id=theorem_id,
        domain=domain,
        tactics_used=tactics or ["induction", "simp", "omega"],
        mathlib_lemmas=lemmas or ["Finset.sum_range_succ"],
        proof_structure=structure,
        difficulty=difficulty,
        winning_model="deepseek/deepseek-reasoner",
        winning_tier="direct",
        mathematical_objects=objects or ["Finset.sum", "\u2115"],
        error_types_encountered=errors or [],
    )


class TestStrategyKB:
    def test_add_and_size(self):
        kb = StrategyKB()
        assert kb.size == 0
        kb.add(_make_profile())
        assert kb.size == 1

    def test_query_by_domain(self):
        kb = StrategyKB()
        kb.add(_make_profile(theorem_id="nt1", domain="number_theory"))
        kb.add(_make_profile(theorem_id="nt2", domain="number_theory"))
        kb.add(_make_profile(theorem_id="alg1", domain="algebra"))

        results = kb.query(domain="number_theory")
        assert len(results) == 2
        assert all(r.similar_theorem_id.startswith("nt") for r in results)

    def test_query_by_mathematical_objects(self):
        kb = StrategyKB()
        kb.add(_make_profile(theorem_id="t1", objects=["Finset.sum", "\u2115"]))
        kb.add(_make_profile(theorem_id="t2", objects=["\u211d", "Real.sqrt"]))
        kb.add(_make_profile(theorem_id="t3", objects=["Finset.sum", "\u2124"]))

        results = kb.query(mathematical_objects=["Finset.sum"])
        # t1 and t3 share Finset.sum
        ids = {r.similar_theorem_id for r in results}
        assert "t1" in ids
        assert "t3" in ids

    def test_query_by_statement_keywords(self):
        kb = StrategyKB()
        kb.add(_make_profile(theorem_id="sum_of_squares_formula"))
        kb.add(_make_profile(theorem_id="prime_factorization"))

        results = kb.query(statement="sum of squares")
        # Should match "sum_of_squares_formula" due to keyword overlap
        assert len(results) >= 1
        ids = {r.similar_theorem_id for r in results}
        assert "sum_of_squares_formula" in ids

    def test_query_empty_kb(self):
        kb = StrategyKB()
        results = kb.query(domain="anything")
        assert results == []

    def test_query_no_match(self):
        kb = StrategyKB()
        kb.add(_make_profile(domain="topology"))
        results = kb.query(domain="number_theory")
        assert results == []

    def test_query_top_k(self):
        kb = StrategyKB()
        for i in range(10):
            kb.add(_make_profile(theorem_id=f"nt_{i}", domain="number_theory"))
        results = kb.query(domain="number_theory", top_k=3)
        assert len(results) == 3

    def test_query_confidence_bounded(self):
        kb = StrategyKB()
        kb.add(_make_profile(
            domain="number_theory",
            objects=["Finset.sum", "\u2115", "\u2124"],
        ))
        results = kb.query(
            domain="number_theory",
            mathematical_objects=["Finset.sum", "\u2115", "\u2124"],
            statement="sum first n numbers",
        )
        for r in results:
            assert 0 <= r.confidence <= 1.0

    def test_domain_stats(self):
        kb = StrategyKB()
        kb.add(_make_profile(
            theorem_id="t1", domain="number_theory",
            tactics=["induction", "simp"], difficulty=3,
            structure="induction",
        ))
        kb.add(_make_profile(
            theorem_id="t2", domain="number_theory",
            tactics=["simp", "omega"], difficulty=5,
            structure="direct",
        ))
        kb.add(_make_profile(
            theorem_id="t3", domain="algebra",
            tactics=["ring"], difficulty=1,
        ))

        stats = kb.get_domain_stats("number_theory")
        assert stats.total_proofs == 2
        assert stats.avg_difficulty == 4.0  # (3 + 5) / 2
        # simp appears in both → count=2
        tactic_dict = dict(stats.top_tactics)
        assert tactic_dict.get("simp", 0) == 2

    def test_domain_stats_empty(self):
        kb = StrategyKB()
        stats = kb.get_domain_stats("nonexistent")
        assert stats.total_proofs == 0
        assert stats.avg_difficulty == 0.0
        assert stats.top_tactics == []

    def test_save_load_roundtrip(self, tmp_path):
        kb = StrategyKB()
        kb.add(_make_profile(theorem_id="t1", domain="number_theory"))
        kb.add(_make_profile(theorem_id="t2", domain="algebra",
                             tactics=["ring"], lemmas=["Ring.inv_eq"]))

        save_path = tmp_path / "kb.json"
        kb.save(save_path)
        assert save_path.exists()

        kb2 = StrategyKB()
        kb2.load(save_path)
        assert kb2.size == 2

        # Verify data integrity
        results = kb2.query(domain="number_theory")
        assert len(results) == 1
        assert results[0].similar_theorem_id == "t1"

        results2 = kb2.query(domain="algebra")
        assert len(results2) == 1
        assert results2[0].similar_theorem_id == "t2"
        assert "ring" in results2[0].recommended_tactics

    def test_load_nonexistent(self, tmp_path):
        kb = StrategyKB()
        kb.load(tmp_path / "nope.json")
        assert kb.size == 0  # no crash

    def test_format_strategy_hints_produces_text(self):
        kb = StrategyKB()
        kb.add(_make_profile(domain="number_theory", tactics=["induction", "simp"]))
        kb.add(_make_profile(domain="number_theory", tactics=["induction", "omega"]))

        hints = kb.format_strategy_hints(domain="number_theory")
        assert "Strategy hints" in hints
        assert "Recommended tactics" in hints
        assert "`induction`" in hints

    def test_format_strategy_hints_empty_for_no_matches(self):
        kb = StrategyKB()
        hints = kb.format_strategy_hints(domain="topology")
        assert hints == ""

    def test_format_strategy_hints_empty_kb(self):
        kb = StrategyKB()
        hints = kb.format_strategy_hints(domain="number_theory")
        assert hints == ""

    def test_format_includes_proof_structure(self):
        kb = StrategyKB()
        kb.add(_make_profile(domain="algebra", structure="contradiction"))
        hints = kb.format_strategy_hints(domain="algebra")
        assert "contradiction" in hints

    def test_format_includes_lemmas(self):
        kb = StrategyKB()
        kb.add(_make_profile(
            domain="number_theory",
            lemmas=["Nat.Prime.dvd_mul"],
        ))
        hints = kb.format_strategy_hints(domain="number_theory")
        assert "Nat.Prime.dvd_mul" in hints


# ---------------------------------------------------------------------------
# build_from_rosetta tests
# ---------------------------------------------------------------------------

class TestBuildFromRosetta:
    def test_build_from_rosetta_jsonl(self, tmp_path):
        rosetta = tmp_path / "rosetta_stone.jsonl"
        entries = [
            {
                "id": "sum_first_n",
                "statement": "Sum of first n natural numbers",
                "nl_proof": "By induction.",
                "lean_code": SIMPLE_PROOF,
                "mathlib_identifiers": ["Finset.sum_range_succ"],
                "attempts": 2,
                "model": "deepseek/deepseek-reasoner",
            },
            {
                "id": "sqrt2_irrational",
                "statement": "Square root of 2 is irrational",
                "nl_proof": "By contradiction.",
                "lean_code": CONTRADICTION_PROOF,
                "mathlib_identifiers": ["Real.sqrt", "Irrational"],
                "attempts": 5,
                "model": "gemini/gemini-2.5-pro",
            },
        ]
        with open(rosetta, "w", encoding="utf-8") as f:
            for entry in entries:
                f.write(json.dumps(entry) + "\n")

        kb = build_from_rosetta(rosetta)
        assert kb.size == 2

        # Query should find results
        results = kb.query(statement="sum of first n")
        assert len(results) >= 1

    def test_build_from_rosetta_with_triples(self, tmp_path):
        rosetta = tmp_path / "rosetta_stone.jsonl"
        entry = {
            "id": "test_thm",
            "statement": "Test theorem",
            "lean_code": SIMPLE_PROOF,
            "mathlib_identifiers": [],
            "attempts": 3,
            "model": "deepseek/deepseek-reasoner",
        }
        with open(rosetta, "w", encoding="utf-8") as f:
            f.write(json.dumps(entry) + "\n")

        triples_dir = tmp_path / "triples"
        triples_dir.mkdir()
        triples = [
            {"structured_proof": {"theorem_name": "test_thm"}, "compiled": False,
             "compiler_output": "unknown constant `Foo`", "lean_code": "bad",
             "model": "deepseek/deepseek-reasoner", "attempt_number": 1,
             "reasoning": ""},
            {"structured_proof": {"theorem_name": "test_thm"}, "compiled": True,
             "compiler_output": "", "lean_code": SIMPLE_PROOF,
             "model": "deepseek/deepseek-reasoner", "attempt_number": 2,
             "reasoning": ""},
        ]
        (triples_dir / "test_thm_20260318.json").write_text(json.dumps(triples))

        kb = build_from_rosetta(rosetta, triples_dir)
        assert kb.size == 1

    def test_build_empty_file(self, tmp_path):
        rosetta = tmp_path / "rosetta_stone.jsonl"
        rosetta.write_text("")
        kb = build_from_rosetta(rosetta)
        assert kb.size == 0

    def test_build_nonexistent(self, tmp_path):
        kb = build_from_rosetta(tmp_path / "nope.jsonl")
        assert kb.size == 0

    def test_build_malformed_lines_skipped(self, tmp_path):
        rosetta = tmp_path / "rosetta_stone.jsonl"
        with open(rosetta, "w", encoding="utf-8") as f:
            f.write("not json\n")
            f.write(json.dumps({
                "id": "valid",
                "statement": "test",
                "lean_code": DIRECT_PROOF,
                "attempts": 1,
                "model": "m",
            }) + "\n")
            f.write("{invalid json\n")

        kb = build_from_rosetta(rosetta)
        assert kb.size == 1


# ---------------------------------------------------------------------------
# Domain inference
# ---------------------------------------------------------------------------

class TestDomainInference:
    def test_infer_number_theory(self):
        assert _infer_domain("Prime_Number_Theorem") == "number_theory"
        assert _infer_domain("Euler_Totient_Function") == "number_theory"

    def test_infer_algebra(self):
        assert _infer_domain("Polynomial_Division_Theorem") == "algebra"

    def test_infer_analysis(self):
        assert _infer_domain("Convergence_of_Series") == "analysis"

    def test_infer_unknown(self):
        assert _infer_domain("some_obscure_name_xyz") == ""


# ---------------------------------------------------------------------------
# Keyword extraction
# ---------------------------------------------------------------------------

class TestKeywordExtraction:
    def test_basic_keywords(self):
        kw = _extract_keywords("For all prime numbers p, if p divides n")
        assert "prime" in kw
        assert "numbers" in kw
        assert "divides" in kw
        # Stop words should be excluded
        assert "for" not in kw
        assert "all" not in kw
        assert "if" not in kw

    def test_empty_string(self):
        assert _extract_keywords("") == set()

    def test_short_words_filtered(self):
        kw = _extract_keywords("a b c of in to")
        assert len(kw) == 0  # all are stop words or too short


# ---------------------------------------------------------------------------
# Integration: strategy hints into translator prompt
# ---------------------------------------------------------------------------

class TestTranslatorIntegration:
    def test_strategy_hints_injected_when_kb_available(self):
        """Verify that format_strategy_hints returns non-empty text
        when the KB has matching data, suitable for prompt injection."""
        kb = StrategyKB()
        for i in range(5):
            kb.add(_make_profile(
                theorem_id=f"nt_{i}",
                domain="number_theory",
                tactics=["induction", "simp", "omega"],
                lemmas=["Finset.sum_range_succ", "Nat.add_comm"],
            ))

        hints = kb.format_strategy_hints(
            domain="number_theory",
            mathematical_objects=["Finset.sum"],
            statement="Sum of first n integers equals n*(n+1)/2",
        )
        assert len(hints) > 0
        assert "Strategy hints" in hints
        assert "Recommended tactics" in hints
        assert "`induction`" in hints

    def test_no_hints_when_kb_empty(self):
        """Empty KB produces empty hints (no prompt bloat)."""
        kb = StrategyKB()
        hints = kb.format_strategy_hints(
            domain="number_theory",
            statement="anything",
        )
        assert hints == ""

    def test_hints_concise(self):
        """Strategy hints should be concise (under ~15 lines)."""
        kb = StrategyKB()
        for i in range(20):
            kb.add(_make_profile(
                theorem_id=f"nt_{i}",
                domain="number_theory",
            ))

        hints = kb.format_strategy_hints(domain="number_theory", top_k=3)
        lines = [l for l in hints.split("\n") if l.strip()]
        assert len(lines) <= 15

    def test_translator_get_strategy_hints_method(self):
        """Test that TranslatorAgent._get_strategy_hints works with a KB."""
        from leanknowledge.agents.translator import TranslatorAgent, LeanCompiler
        from leanknowledge.schemas import ExtractedItem, StatementType, ClaimRole

        class DummyCompiler(LeanCompiler):
            def compile(self, code):
                return False, "err"

        kb = StrategyKB()
        kb.add(_make_profile(
            domain="number_theory",
            tactics=["induction", "omega"],
            lemmas=["Finset.sum_range_succ"],
        ))

        agent = TranslatorAgent(
            compiler=DummyCompiler(),
            strategy_kb=kb,
        )

        item = ExtractedItem(
            id="test_item",
            type=StatementType.THEOREM,
            role=ClaimRole.CLAIMED_RESULT,
            statement="For all n, sum of first n = n*(n+1)/2",
            section="Number Theory",
        )

        hints = agent._get_strategy_hints(item)
        assert "Strategy hints" in hints
        assert "`induction`" in hints or "`omega`" in hints

    def test_translator_get_strategy_hints_none_kb(self):
        """No hints when strategy_kb is None."""
        from leanknowledge.agents.translator import TranslatorAgent, LeanCompiler
        from leanknowledge.schemas import ExtractedItem, StatementType, ClaimRole

        class DummyCompiler(LeanCompiler):
            def compile(self, code):
                return False, "err"

        agent = TranslatorAgent(compiler=DummyCompiler(), strategy_kb=None)

        item = ExtractedItem(
            id="test_item",
            type=StatementType.THEOREM,
            role=ClaimRole.CLAIMED_RESULT,
            statement="anything",
            section="Number Theory",
        )

        hints = agent._get_strategy_hints(item)
        assert hints == ""

    def test_translator_get_strategy_hints_no_item(self):
        """No hints when item is None."""
        from leanknowledge.agents.translator import TranslatorAgent, LeanCompiler

        class DummyCompiler(LeanCompiler):
            def compile(self, code):
                return False, "err"

        kb = StrategyKB()
        kb.add(_make_profile(domain="number_theory"))
        agent = TranslatorAgent(compiler=DummyCompiler(), strategy_kb=kb)

        hints = agent._get_strategy_hints(None)
        assert hints == ""
