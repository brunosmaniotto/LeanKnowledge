"""Tests for Rosetta screening — dependency context injection into translator prompts."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "src"))

from leanknowledge.schemas import (
    ExtractedItem, StatementType, ClaimRole,
)
from leanknowledge.agents.translator import TranslatorAgent, LeanCompiler
from leanknowledge.mathlib_index import MathlibIndex, Declaration


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _item(deps: list[str] | None = None) -> ExtractedItem:
    return ExtractedItem(
        id="Theorem_1.A.1",
        type=StatementType.THEOREM,
        role=ClaimRole.CLAIMED_RESULT,
        statement="For all x, f(x) > 0.",
        proof="By Definition_1.B.1 and Proposition_1.C.1.",
        section="1.A",
        dependencies=deps or [],
    )


def _index_with_rosetta(entries: list[dict]) -> MathlibIndex:
    """Build a MathlibIndex with hand-crafted rosetta entries."""
    idx = MathlibIndex(use_embeddings=False)
    decls = []
    for e in entries:
        decls.append({
            "name": e["name"],
            "signature": e.get("signature", ""),
            "docstring": e.get("docstring", ""),
            "source": "rosetta",
        })
    idx.add_declarations(decls)
    return idx


class StubCompiler(LeanCompiler):
    def compile(self, code: str) -> tuple[bool, str]:
        return False, "error: stub"


# ---------------------------------------------------------------------------
# Tests for _get_dependency_context
# ---------------------------------------------------------------------------

def test_empty_dependencies():
    """No dependencies → empty string."""
    idx = _index_with_rosetta([])
    agent = TranslatorAgent(compiler=StubCompiler(), mathlib_index=idx)
    result = agent._get_dependency_context(_item(deps=[]))
    assert result == ""


def test_no_mathlib_index():
    """No index at all → empty string."""
    agent = TranslatorAgent(compiler=StubCompiler(), mathlib_index=None)
    result = agent._get_dependency_context(_item(deps=["Definition_1.B.1"]))
    assert result == ""


def test_none_item():
    """None item → empty string."""
    idx = _index_with_rosetta([])
    agent = TranslatorAgent(compiler=StubCompiler(), mathlib_index=idx)
    result = agent._get_dependency_context(None)
    assert result == ""


def test_dependency_found_in_rosetta():
    """Dependency with a matching rosetta entry returns formatted Lean code."""
    idx = _index_with_rosetta([{
        "name": "Definition_1.B.1",
        "signature": "def rational_preferences (X : Type) := ...",
        "docstring": "A preference relation is rational if it is complete and transitive.",
    }])
    agent = TranslatorAgent(compiler=StubCompiler(), mathlib_index=idx)
    result = agent._get_dependency_context(_item(deps=["Definition_1.B.1"]))
    assert "## Proven Dependencies" in result
    assert "Definition_1.B.1" in result
    assert "rational_preferences" in result
    assert "```lean" in result


def test_dependency_not_found():
    """Dependency not in index → skipped gracefully."""
    idx = _index_with_rosetta([{
        "name": "Definition_1.B.1",
        "signature": "def rational_preferences (X : Type) := ...",
        "docstring": "Rational prefs",
    }])
    agent = TranslatorAgent(compiler=StubCompiler(), mathlib_index=idx)
    # Ask for a dependency that's NOT in the index
    result = agent._get_dependency_context(_item(deps=["Proposition_99.Z.1"]))
    assert result == ""


def test_mixed_found_and_not_found():
    """Mix of found and missing dependencies → only found ones appear."""
    idx = _index_with_rosetta([{
        "name": "Definition_1.B.1",
        "signature": "def rational_preferences := sorry",
        "docstring": "Rational prefs",
    }])
    agent = TranslatorAgent(compiler=StubCompiler(), mathlib_index=idx)
    result = agent._get_dependency_context(
        _item(deps=["Definition_1.B.1", "Missing_Thing"])
    )
    assert "Definition_1.B.1" in result
    assert "Missing_Thing" not in result


def test_external_deps_skipped():
    """External: dependencies are skipped (not in rosetta)."""
    idx = _index_with_rosetta([{
        "name": "External:Zorns_lemma",
        "signature": "axiom zorns_lemma ...",
        "docstring": "Zorn's lemma",
    }])
    agent = TranslatorAgent(compiler=StubCompiler(), mathlib_index=idx)
    result = agent._get_dependency_context(
        _item(deps=["External:Zorns_lemma"])
    )
    assert result == ""


def test_non_rosetta_source_skipped():
    """Declarations from mathlib source (not rosetta) are not included."""
    idx = MathlibIndex(use_embeddings=False)
    idx.add_declarations([{
        "name": "Definition_1.B.1",
        "signature": "def something := sorry",
        "docstring": "From mathlib",
        "source": "mathlib",
    }])
    agent = TranslatorAgent(compiler=StubCompiler(), mathlib_index=idx)
    result = agent._get_dependency_context(_item(deps=["Definition_1.B.1"]))
    assert result == ""


def test_empty_signature_skipped():
    """Rosetta entries with no signature are skipped."""
    idx = _index_with_rosetta([{
        "name": "Definition_1.B.1",
        "signature": "",
        "docstring": "Rational prefs",
    }])
    agent = TranslatorAgent(compiler=StubCompiler(), mathlib_index=idx)
    result = agent._get_dependency_context(_item(deps=["Definition_1.B.1"]))
    assert result == ""


def test_multiple_dependencies_found():
    """Multiple dependencies found → all included in output."""
    idx = _index_with_rosetta([
        {
            "name": "Definition_1.B.1",
            "signature": "def rational_prefs := sorry",
            "docstring": "Rational preferences",
        },
        {
            "name": "Proposition_1.C.1",
            "signature": "theorem prop_1c1 : True := trivial",
            "docstring": "WARP implies rational",
        },
    ])
    agent = TranslatorAgent(compiler=StubCompiler(), mathlib_index=idx)
    result = agent._get_dependency_context(
        _item(deps=["Definition_1.B.1", "Proposition_1.C.1"])
    )
    assert "Definition_1.B.1" in result
    assert "Proposition_1.C.1" in result
    assert "rational_prefs" in result
    assert "prop_1c1" in result


def test_get_by_name_returns_declaration():
    """MathlibIndex.get_by_name returns the Declaration object."""
    idx = _index_with_rosetta([{
        "name": "Theorem_X",
        "signature": "theorem x : True := trivial",
        "docstring": "Test theorem",
    }])
    decl = idx.get_by_name("Theorem_X")
    assert decl is not None
    assert isinstance(decl, Declaration)
    assert decl.name == "Theorem_X"
    assert decl.source == "rosetta"


def test_get_by_name_returns_none_for_missing():
    """MathlibIndex.get_by_name returns None for missing names."""
    idx = _index_with_rosetta([])
    assert idx.get_by_name("NonExistent") is None
