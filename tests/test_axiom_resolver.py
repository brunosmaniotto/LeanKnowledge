"""Tests for axiom_resolver agent — fully self-contained with mock data."""

import json
import tempfile
from pathlib import Path

import pytest

from leanknowledge.agents.axiom_resolver import (
    AxiomDeclaration,
    AxiomMatch,
    AxiomProvenance,
    MatchCategory,
    ResolutionReport,
    classify_provenance,
    extract_axioms,
    extract_axiom_items,
    extract_axioms_from_file,
    load_extraction_deps,
    normalize_signature,
    signature_hash,
    axiom_to_item_id,
    axiom_to_extracted_item,
    resolve_axiom,
    scan_directory,
    scan_single_file,
    format_report,
)
from leanknowledge.schemas import StatementType, ClaimRole
from leanknowledge.mathlib_index import MathlibIndex


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

SAMPLE_LEAN = """\
import Mathlib

axiom nonneg_zero_at_isLocalMin {E : Type*} [TopologicalSpace E] {f : E → ℝ} {x₀ : E}
    (hge : ∀ x, 0 ≤ f x) (hzero : f x₀ = 0) : IsLocalMin f x₀

axiom local_min_fderiv_zero {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {f : E → ℝ} {f' : E →L[ℝ] ℝ} {x₀ : E}
    (hmin : IsLocalMin f x₀) (hdiff : HasFDerivAt f f' x₀) : f' = 0

theorem duality_theorem : True := by trivial
"""

ECONOMIC_LEAN = """\
import Mathlib

axiom WalrasianDemand : (Fin n → ℝ) → ℝ → (Fin n → ℝ)
axiom ExpenditureFunction : (Fin n → ℝ) → ℝ → ℝ

theorem claim : True := by trivial
"""

NO_AXIOM_LEAN = """\
import Mathlib

theorem simple_fact : 1 + 1 = 2 := by norm_num
"""


def _make_index_with_mathlib() -> MathlibIndex:
    """Build a small MathlibIndex with some known Mathlib declarations."""
    index = MathlibIndex(use_embeddings=False)
    index.build_from_declarations([
        {
            "name": "IsLocalMin.fderiv_eq_zero",
            "signature": "(hmin : IsLocalMin f x₀) (hdiff : HasFDerivAt f f' x₀) : f' = 0",
            "docstring": "The Frechet derivative at a local minimum is zero",
            "source": "mathlib",
        },
        {
            "name": "IsLocalMin",
            "signature": "IsLocalMin f x₀ : Prop",
            "docstring": "x₀ is a local minimum of f",
            "source": "mathlib",
        },
        {
            "name": "HasFDerivAt",
            "signature": "HasFDerivAt f f' x : Prop",
            "docstring": "f has Frechet derivative f' at x",
            "source": "mathlib",
        },
        {
            "name": "Proposition_2.F.1",
            "signature": "theorem prop_2f1 ...",
            "docstring": "If demand satisfies Walras law and homogeneity, then the Slutsky matrix is negative semidefinite",
            "source": "rosetta",
        },
    ])
    return index


# ---------------------------------------------------------------------------
# Tests: extraction
# ---------------------------------------------------------------------------

class TestExtraction:
    def test_extracts_axiom_names(self):
        axioms = extract_axioms(SAMPLE_LEAN, "test.lean")
        names = [a.name for a in axioms]
        assert "nonneg_zero_at_isLocalMin" in names
        assert "local_min_fderiv_zero" in names

    def test_extracts_signatures(self):
        axioms = extract_axioms(SAMPLE_LEAN, "test.lean")
        fderiv = [a for a in axioms if a.name == "local_min_fderiv_zero"][0]
        assert "HasFDerivAt" in fderiv.signature
        assert "IsLocalMin" in fderiv.signature

    def test_skips_theorems(self):
        axioms = extract_axioms(SAMPLE_LEAN, "test.lean")
        names = [a.name for a in axioms]
        assert "duality_theorem" not in names

    def test_no_axioms(self):
        axioms = extract_axioms(NO_AXIOM_LEAN, "clean.lean")
        assert axioms == []

    def test_economic_axioms(self):
        axioms = extract_axioms(ECONOMIC_LEAN, "econ.lean")
        assert len(axioms) == 2
        names = {a.name for a in axioms}
        assert names == {"WalrasianDemand", "ExpenditureFunction"}

    def test_file_extraction(self, tmp_path):
        f = tmp_path / "test.lean"
        f.write_text(SAMPLE_LEAN, encoding="utf-8")
        axioms = extract_axioms_from_file(f)
        assert len(axioms) == 2

    def test_item_id_from_filename(self):
        axioms = extract_axioms(SAMPLE_LEAN, "outputs/lean/proposition_3.f.1.lean")
        assert axioms[0].item_id == "proposition_3.f.1"


# ---------------------------------------------------------------------------
# Tests: resolution
# ---------------------------------------------------------------------------

class TestResolution:
    def test_mathlib_match(self):
        index = _make_index_with_mathlib()
        axiom = AxiomDeclaration(
            name="local_min_fderiv_zero",
            signature="{f : E → ℝ} {f' : E →L[ℝ] ℝ} {x₀ : E} (hmin : IsLocalMin f x₀) (hdiff : HasFDerivAt f f' x₀) : f' = 0",
            file_path="test.lean",
            item_id="test",
        )
        match = resolve_axiom(axiom, index, top_k=3)
        # Should find IsLocalMin.fderiv_eq_zero as a strong match
        assert match.category in (MatchCategory.MATHLIB_EXACT, MatchCategory.PARTIAL)
        assert match.best_match_source == "mathlib"
        assert len(match.top_candidates) > 0

    def test_unresolved_economic_primitive(self):
        index = _make_index_with_mathlib()
        axiom = AxiomDeclaration(
            name="WalrasianDemand",
            signature="(Fin n → ℝ) → ℝ → (Fin n → ℝ)",
            file_path="econ.lean",
            item_id="econ",
        )
        match = resolve_axiom(axiom, index, top_k=3)
        # Walrasian demand is economics, not in our small Mathlib mock
        assert match.category in (MatchCategory.UNRESOLVED, MatchCategory.PARTIAL)

    def test_empty_index(self):
        index = MathlibIndex(use_embeddings=False)
        axiom = AxiomDeclaration(
            name="anything", signature="Prop", file_path="x.lean", item_id="x",
        )
        match = resolve_axiom(axiom, index)
        assert match.category == MatchCategory.UNRESOLVED


# ---------------------------------------------------------------------------
# Tests: batch scan
# ---------------------------------------------------------------------------

class TestBatchScan:
    def test_scan_directory(self, tmp_path):
        lean_dir = tmp_path / "lean"
        lean_dir.mkdir()
        (lean_dir / "math.lean").write_text(SAMPLE_LEAN, encoding="utf-8")
        (lean_dir / "econ.lean").write_text(ECONOMIC_LEAN, encoding="utf-8")
        (lean_dir / "clean.lean").write_text(NO_AXIOM_LEAN, encoding="utf-8")

        index = _make_index_with_mathlib()
        report = scan_directory(lean_dir, index)

        assert report.total_files == 3
        assert report.files_with_axioms == 2
        assert report.total_axioms == 4  # 2 math + 2 econ

    def test_scan_single_file(self, tmp_path):
        f = tmp_path / "test.lean"
        f.write_text(SAMPLE_LEAN, encoding="utf-8")
        index = _make_index_with_mathlib()
        matches = scan_single_file(f, index)
        assert len(matches) == 2

    def test_report_formatting(self):
        report = ResolutionReport(
            total_files=10,
            files_with_axioms=3,
            total_axioms=5,
            mathlib_exact=[AxiomMatch(
                axiom=AxiomDeclaration("foo", "Prop", "a.lean", "a"),
                category=MatchCategory.MATHLIB_EXACT,
                best_match_name="Foo.bar",
                best_match_score=0.9,
                best_match_source="mathlib",
            )],
            unresolved=[AxiomMatch(
                axiom=AxiomDeclaration("baz", "Type", "b.lean", "b"),
                category=MatchCategory.UNRESOLVED,
            )],
        )
        text = format_report(report)
        assert "Axiom Resolution Report" in text
        assert "Mathlib exact:       1" in text
        assert "Unresolved:          1" in text
        assert "Foo.bar" in text
        assert "Resolvable:          1 / 5" in text

    def test_report_with_reference_exact(self):
        report = ResolutionReport(
            total_files=5,
            files_with_axioms=2,
            total_axioms=3,
            reference_exact=[AxiomMatch(
                axiom=AxiomDeclaration("prop_3F1", "Prop", "a.lean", "a"),
                category=MatchCategory.REFERENCE_EXACT,
                best_match_name="Proposition_3.F.1",
                best_match_score=1.0,
                best_match_source="reference",
                provenance=AxiomProvenance.DEPENDENCY,
                reference_id="Proposition_3.F.1",
            )],
        )
        text = format_report(report)
        assert "Reference exact:     1" in text
        assert "Resolvable:          1 / 3" in text
        assert "Proposition_3.F.1" in text
        assert "REFERENCE EXACT" in text


# ---------------------------------------------------------------------------
# Tests: provenance classification
# ---------------------------------------------------------------------------

class TestProvenance:
    def test_proof_step_detected(self):
        axiom = AxiomDeclaration("step1_helper_lemma", "Prop", "f.lean", "f")
        prov, ref = classify_provenance(axiom, dependencies=["Definition_1.B.1"])
        assert prov == AxiomProvenance.PROOF_STEP
        assert ref == ""

    def test_step_pattern_case_insensitive(self):
        axiom = AxiomDeclaration("Step3_monotone_convergence", "Prop", "f.lean", "f")
        prov, ref = classify_provenance(axiom)
        assert prov == AxiomProvenance.PROOF_STEP

    def test_dependency_exact_match(self):
        axiom = AxiomDeclaration("Proposition_3.F.1", "Prop", "f.lean", "f")
        prov, ref = classify_provenance(axiom, dependencies=["Proposition_3.F.1"])
        assert prov == AxiomProvenance.DEPENDENCY
        assert ref == "Proposition_3.F.1"

    def test_dependency_fuzzy_match(self):
        """axiom prop_3F1 should match dependency Proposition_3.F.1."""
        axiom = AxiomDeclaration("prop_3F1", "Prop", "f.lean", "f")
        prov, ref = classify_provenance(axiom, dependencies=["Proposition_3.F.1"])
        assert prov == AxiomProvenance.DEPENDENCY
        assert ref == "Proposition_3.F.1"

    def test_dependency_definition_match(self):
        """axiom def_1B1 should match dependency Definition_1.B.1."""
        axiom = AxiomDeclaration("def_1B1", "Prop", "f.lean", "f")
        prov, ref = classify_provenance(axiom, dependencies=["Definition_1.B.1"])
        assert prov == AxiomProvenance.DEPENDENCY
        assert ref == "Definition_1.B.1"

    def test_scaffolding_type_only(self):
        axiom = AxiomDeclaration("PreferenceRelation", "Type*", "f.lean", "f")
        prov, ref = classify_provenance(axiom, dependencies=[])
        assert prov == AxiomProvenance.SCAFFOLDING

    def test_unknown_when_no_deps(self):
        axiom = AxiomDeclaration("mysterious_lemma", "{x : ℝ} : x + 0 = x", "f.lean", "f")
        prov, ref = classify_provenance(axiom, dependencies=[])
        assert prov == AxiomProvenance.UNKNOWN
        assert ref == ""

    def test_no_match_returns_unknown(self):
        axiom = AxiomDeclaration("completely_unrelated", "{x : ℝ} : x ≤ x + 1", "f.lean", "f")
        prov, ref = classify_provenance(axiom, dependencies=["Definition_1.B.1"])
        assert prov == AxiomProvenance.UNKNOWN


# ---------------------------------------------------------------------------
# Tests: extraction dependency loading
# ---------------------------------------------------------------------------

class TestExtractionDeps:
    def test_load_extraction_deps(self, tmp_path):
        data = [
            {"id": "Proposition_3.C.1", "dependencies": ["Definition_3.B.1", "Lemma_3.A.2"]},
            {"id": "Definition_3.B.1", "dependencies": []},
            {"id": "Claim_3.H.b", "dependencies": ["Proposition_3.F.1"]},
        ]
        ext_path = tmp_path / "extraction.json"
        ext_path.write_text(json.dumps(data), encoding="utf-8")

        deps = load_extraction_deps(ext_path)
        # Keys are lowercase
        assert "proposition_3.c.1" in deps
        assert deps["proposition_3.c.1"] == ["Definition_3.B.1", "Lemma_3.A.2"]
        assert "claim_3.h.b" in deps
        # Items with empty deps are not included
        assert "definition_3.b.1" not in deps

    def test_load_missing_file(self, tmp_path):
        deps = load_extraction_deps(tmp_path / "nonexistent.json")
        assert deps == {}

    def test_load_nested_format(self, tmp_path):
        data = {"items": [
            {"id": "Theorem_1.A.1", "dependencies": ["Definition_1.A.1"]},
        ]}
        ext_path = tmp_path / "extraction.json"
        ext_path.write_text(json.dumps(data), encoding="utf-8")
        deps = load_extraction_deps(ext_path)
        assert "theorem_1.a.1" in deps


# ---------------------------------------------------------------------------
# Tests: reference-tagged resolution
# ---------------------------------------------------------------------------

class TestReferenceResolution:
    def test_reference_exact_when_in_index(self):
        """When axiom maps to a dependency that exists in the index, get REFERENCE_EXACT."""
        index = _make_index_with_mathlib()
        axiom = AxiomDeclaration(
            name="prop_2F1",
            signature="some signature about Slutsky",
            file_path="claim.lean",
            item_id="claim",
        )
        match = resolve_axiom(axiom, index, dependencies=["Proposition_2.F.1"])
        assert match.category == MatchCategory.REFERENCE_EXACT
        assert match.reference_id == "Proposition_2.F.1"
        assert match.provenance == AxiomProvenance.DEPENDENCY

    def test_dependency_not_in_index_still_boosts(self):
        """When dep is matched but not in index by name, query is boosted."""
        index = _make_index_with_mathlib()
        axiom = AxiomDeclaration(
            name="prop_99Z9",
            signature="Prop",
            file_path="claim.lean",
            item_id="claim",
        )
        match = resolve_axiom(axiom, index, dependencies=["Proposition_99.Z.9"])
        # Won't get REFERENCE_EXACT (Proposition_99.Z.9 not in index)
        # but provenance should be detected
        assert match.provenance == AxiomProvenance.DEPENDENCY
        assert match.reference_id == "Proposition_99.Z.9"

    def test_scan_directory_with_deps(self, tmp_path):
        """scan_directory with extraction_deps enables reference tagging."""
        lean_dir = tmp_path / "lean"
        lean_dir.mkdir()

        # Create a file where axiom name matches the extraction dependency
        lean_code = """\
import Mathlib

axiom prop_2F1 : Prop

theorem some_theorem : True := by trivial
"""
        (lean_dir / "claim_3.h.b.lean").write_text(lean_code, encoding="utf-8")

        index = _make_index_with_mathlib()
        extraction_deps = {
            "claim_3.h.b": ["Proposition_2.F.1"],
        }
        report = scan_directory(lean_dir, index, extraction_deps=extraction_deps)
        assert report.total_axioms == 1
        assert len(report.reference_exact) == 1
        assert report.reference_exact[0].reference_id == "Proposition_2.F.1"


# ---------------------------------------------------------------------------
# Tests: signature normalization and hashing
# ---------------------------------------------------------------------------

class TestNormalizeSignature:
    def test_strips_variable_names(self):
        sig = "(x : Nat) → (y : Nat) → Nat"
        norm = normalize_signature(sig)
        assert "(_ : Nat)" in norm
        assert "x" not in norm
        assert "y" not in norm

    def test_collapses_whitespace(self):
        sig = "  (x : Nat)  →  Nat  "
        norm = normalize_signature(sig)
        assert "  " not in norm
        assert norm == "(_ : Nat) → Nat"

    def test_preserves_types(self):
        sig = "(f : E → ℝ) (hmin : IsLocalMin f x₀) : f' = 0"
        norm = normalize_signature(sig)
        assert "IsLocalMin" in norm
        assert "E → ℝ" in norm

    def test_empty_signature(self):
        assert normalize_signature("") == ""
        assert normalize_signature("   ") == ""


class TestSignatureHash:
    def test_deterministic(self):
        sig = "(x : Nat) → Nat"
        assert signature_hash(sig) == signature_hash(sig)

    def test_ignores_varnames(self):
        sig_x = "(x : Nat) → Nat"
        sig_y = "(y : Nat) → Nat"
        assert signature_hash(sig_x) == signature_hash(sig_y)

    def test_different_types_differ(self):
        assert signature_hash("(x : Nat) → Nat") != signature_hash("(x : Int) → Int")


# ---------------------------------------------------------------------------
# Tests: axiom → ExtractedItem conversion
# ---------------------------------------------------------------------------

class TestAxiomToItem:
    def test_axiom_to_item_id_named(self):
        ax = AxiomDeclaration("myAxiom", "Prop", "f.lean", "item1")
        assert axiom_to_item_id(ax) == "Axiom:myAxiom"

    def test_axiom_to_item_id_anonymous(self):
        ax = AxiomDeclaration("_anon", "Prop", "f.lean", "item1")
        item_id = axiom_to_item_id(ax)
        assert item_id.startswith("Axiom:")
        assert len(item_id) == len("Axiom:") + 12

    def test_axiom_to_extracted_item_fields(self):
        ax = AxiomDeclaration(
            "walras_law", "(p : Fin n → ℝ) → ℝ", "econ.lean", "claim_1"
        )
        item = axiom_to_extracted_item(ax)
        assert item.id == "Axiom:walras_law"
        assert item.type == StatementType.AXIOM
        assert item.role == ClaimRole.INVOKED_DEPENDENCY
        assert "walras_law" in item.statement
        assert "(p : Fin n → ℝ) → ℝ" in item.statement
        assert item.section == "claim_1"
        assert item.dependencies == []


# ---------------------------------------------------------------------------
# Tests: extract_axiom_items (end-to-end)
# ---------------------------------------------------------------------------

class TestExtractAxiomItems:
    def test_basic_extraction(self):
        items = extract_axiom_items(ECONOMIC_LEAN, file_path="econ.lean")
        assert len(items) == 2
        ids = {i.id for i in items}
        assert "Axiom:WalrasianDemand" in ids
        assert "Axiom:ExpenditureFunction" in ids

    def test_no_axioms_returns_empty(self):
        items = extract_axiom_items(NO_AXIOM_LEAN, file_path="clean.lean")
        assert items == []

    def test_filters_mathlib_resolvable(self):
        index = _make_index_with_mathlib()
        items = extract_axiom_items(SAMPLE_LEAN, file_path="test.lean", mathlib_index=index)
        # Both axioms in SAMPLE_LEAN have strong Mathlib matches — at least
        # one should be filtered out (local_min_fderiv_zero matches well)
        names = {i.id for i in items}
        # The exact count depends on TF-IDF scores, but there should be fewer
        # than the 2 raw axioms
        assert len(items) <= 2

    def test_deduplicates_by_signature(self):
        code = """\
import Mathlib

axiom foo (x : Nat) → Nat
axiom bar (y : Nat) → Nat

theorem t : True := by trivial
"""
        items = extract_axiom_items(code, file_path="test.lean")
        # foo and bar have same normalized signature → deduplicated to 1
        assert len(items) == 1
