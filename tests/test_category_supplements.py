"""Tests for category-specific prompt supplements.

Covers:
  - Category detection from item section and statement text
  - Supplement file loading
  - Integration with prompt assembly (supplements injected into system prompt)
"""

from leanknowledge.schemas import ExtractedItem, StatementType, ClaimRole
from leanknowledge.agents.translator import (
    detect_math_category,
    _load_category_supplement,
    CATEGORY_PROMPTS_DIR,
    _DIRECT_SYSTEM,
)


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _make_item(
    section: str = "Uncategorized",
    statement: str = "1 + 1 = 2",
    **kwargs,
) -> ExtractedItem:
    return ExtractedItem(
        id="test",
        type=StatementType.THEOREM,
        role=ClaimRole.CLAIMED_RESULT,
        statement=statement,
        section=section,
        **kwargs,
    )


# ---------------------------------------------------------------------------
# Category detection — section-based (high confidence)
# ---------------------------------------------------------------------------

class TestCategoryDetectionBySection:
    """Section field comes from dataset metadata (e.g., ProofWiki categories)."""

    def test_probability_theory(self):
        item = _make_item(section="Probability Theory")
        assert detect_math_category(item) == "probability.md"

    def test_measure_theory(self):
        item = _make_item(section="Measure Theory")
        assert detect_math_category(item) == "probability.md"

    def test_trigonometry(self):
        item = _make_item(section="Trigonometry")
        assert detect_math_category(item) == "trigonometry.md"

    def test_geometry(self):
        item = _make_item(section="Geometry")
        assert detect_math_category(item) == "geometry.md"

    def test_euclidean_geometry(self):
        item = _make_item(section="Euclidean Geometry")
        assert detect_math_category(item) == "geometry.md"

    def test_number_theory(self):
        item = _make_item(section="Number Theory")
        assert detect_math_category(item) == "number_theory.md"

    def test_combinatorics(self):
        item = _make_item(section="Combinatorics")
        assert detect_math_category(item) == "combinatorics.md"

    def test_linear_algebra(self):
        item = _make_item(section="Linear Algebra")
        assert detect_math_category(item) == "linear_algebra.md"

    def test_group_theory(self):
        item = _make_item(section="Group Theory")
        assert detect_math_category(item) == "group_theory.md"

    def test_topology(self):
        item = _make_item(section="Topology")
        assert detect_math_category(item) == "topology.md"

    def test_real_analysis(self):
        item = _make_item(section="Real Analysis")
        assert detect_math_category(item) == "analysis.md"

    def test_calculus(self):
        item = _make_item(section="Calculus")
        assert detect_math_category(item) == "analysis.md"

    def test_set_theory(self):
        item = _make_item(section="Set Theory")
        assert detect_math_category(item) == "set_theory.md"

    def test_algebra(self):
        item = _make_item(section="Algebra")
        assert detect_math_category(item) == "algebra.md"

    def test_logic(self):
        item = _make_item(section="Logic")
        assert detect_math_category(item) == "logic.md"

    def test_order_theory(self):
        item = _make_item(section="Order Theory")
        assert detect_math_category(item) == "order_theory.md"

    def test_case_insensitive(self):
        item = _make_item(section="NUMBER THEORY")
        assert detect_math_category(item) == "number_theory.md"

    def test_unknown_section_returns_none(self):
        item = _make_item(section="Uncategorized")
        assert detect_math_category(item) is None

    def test_empty_section_returns_none(self):
        item = _make_item(section="")
        assert detect_math_category(item) is None


# ---------------------------------------------------------------------------
# Category detection — statement-based (fallback)
# ---------------------------------------------------------------------------

class TestCategoryDetectionByStatement:
    """Fallback when section is generic — keyword matching on statement text."""

    def test_probability_keywords(self):
        item = _make_item(
            statement="Let X be a random variable with expectation E[X] = μ"
        )
        assert detect_math_category(item) == "probability.md"

    def test_trig_keywords(self):
        item = _make_item(
            statement="Prove that sin(x)^2 + cos(x)^2 = 1"
        )
        assert detect_math_category(item) == "trigonometry.md"

    def test_geometry_keywords(self):
        item = _make_item(
            statement="In a triangle ABC, the angle at B is perpendicular to AC"
        )
        assert detect_math_category(item) == "geometry.md"

    def test_number_theory_keywords(self):
        item = _make_item(
            statement="If p is prime and p divides ab, then p divides a or p divides b"
        )
        assert detect_math_category(item) == "number_theory.md"

    def test_group_theory_keywords(self):
        item = _make_item(
            statement="Let H be a subgroup of G. Then the quotient group G/H exists."
        )
        assert detect_math_category(item) == "group_theory.md"

    def test_topology_keywords(self):
        item = _make_item(
            statement="Every compact subset of a Hausdorff space is closed"
        )
        assert detect_math_category(item) == "topology.md"

    def test_combinatorics_keywords(self):
        item = _make_item(
            statement="The binomial coefficient C(n,k) = factorial n / (factorial k * factorial (n-k))"
        )
        assert detect_math_category(item) == "combinatorics.md"

    def test_linear_algebra_keywords(self):
        item = _make_item(
            statement="The determinant of a matrix product equals the product of the determinants"
        )
        assert detect_math_category(item) == "linear_algebra.md"

    def test_generic_statement_returns_none(self):
        item = _make_item(statement="1 + 1 = 2")
        assert detect_math_category(item) is None

    def test_section_takes_priority_over_statement(self):
        """When section matches, don't fall back to statement keywords."""
        item = _make_item(
            section="Number Theory",
            statement="For all primes p, sin(p) > 0",  # has trig keywords too
        )
        # Section match should win
        assert detect_math_category(item) == "number_theory.md"


# ---------------------------------------------------------------------------
# Supplement file loading
# ---------------------------------------------------------------------------

class TestSupplementLoading:
    def test_load_probability(self):
        content = _load_category_supplement("probability.md")
        assert "MeasureTheory" in content
        assert "ProbabilityTheory" in content
        assert len(content) > 100

    def test_load_trigonometry(self):
        content = _load_category_supplement("trigonometry.md")
        assert "Real.sin" in content
        assert "Real.cos" in content

    def test_load_geometry(self):
        content = _load_category_supplement("geometry.md")
        assert "EuclideanGeometry" in content or "InnerProductSpace" in content

    def test_load_number_theory(self):
        content = _load_category_supplement("number_theory.md")
        assert "Nat.Prime" in content

    def test_load_algebra(self):
        content = _load_category_supplement("algebra.md")
        assert "Finset.sum_range_succ" in content

    def test_load_set_theory(self):
        content = _load_category_supplement("set_theory.md")
        assert "Set.mem_union" in content

    def test_load_logic(self):
        content = _load_category_supplement("logic.md")
        assert "tauto" in content

    def test_load_analysis(self):
        content = _load_category_supplement("analysis.md")
        assert "Tendsto" in content or "Filter" in content

    def test_load_topology(self):
        content = _load_category_supplement("topology.md")
        assert "TopologicalSpace" in content

    def test_load_combinatorics(self):
        content = _load_category_supplement("combinatorics.md")
        assert "Nat.choose" in content

    def test_load_linear_algebra(self):
        content = _load_category_supplement("linear_algebra.md")
        assert "Matrix" in content

    def test_load_order_theory(self):
        content = _load_category_supplement("order_theory.md")
        assert "PartialOrder" in content or "Lattice" in content

    def test_load_group_theory(self):
        content = _load_category_supplement("group_theory.md")
        assert "Subgroup" in content

    def test_load_none_returns_empty(self):
        assert _load_category_supplement(None) == ""

    def test_load_nonexistent_returns_empty(self):
        assert _load_category_supplement("nonexistent_category.md") == ""

    def test_load_empty_string_returns_empty(self):
        assert _load_category_supplement("") == ""


# ---------------------------------------------------------------------------
# All supplement files exist and are well-formed
# ---------------------------------------------------------------------------

class TestAllSupplementFiles:
    """Ensure every mapped category file actually exists on disk."""

    def test_all_category_files_exist(self):
        from leanknowledge.agents.translator import _CATEGORY_MAP
        seen_files = set()
        for _, filename in _CATEGORY_MAP:
            seen_files.add(filename)
        for filename in seen_files:
            path = CATEGORY_PROMPTS_DIR / filename
            assert path.exists(), f"Missing supplement file: {path}"

    def test_all_supplements_have_content(self):
        from leanknowledge.agents.translator import _CATEGORY_MAP
        seen_files = set()
        for _, filename in _CATEGORY_MAP:
            seen_files.add(filename)
        for filename in seen_files:
            content = _load_category_supplement(filename)
            assert len(content) > 50, f"Supplement {filename} is too short"

    def test_all_supplements_have_imports_section(self):
        """Every supplement should mention import or open."""
        from leanknowledge.agents.translator import _CATEGORY_MAP
        seen_files = set()
        for _, filename in _CATEGORY_MAP:
            seen_files.add(filename)
        for filename in seen_files:
            content = _load_category_supplement(filename)
            assert "import" in content.lower() or "open" in content.lower(), (
                f"Supplement {filename} missing import/open guidance"
            )


# ---------------------------------------------------------------------------
# Integration: supplements injected into system prompts
# ---------------------------------------------------------------------------

class TestPromptIntegration:
    """Verify that the category supplement is injected into the system prompt.

    We test by checking the _DIRECT_SYSTEM constant does NOT contain category
    content (it's the base prompt), and that category supplements are loaded
    and would be appended.
    """

    def test_direct_system_is_generic(self):
        """The base _DIRECT_SYSTEM should NOT contain domain-specific content."""
        assert "MeasureTheory" not in _DIRECT_SYSTEM
        assert "Real.sin" not in _DIRECT_SYSTEM
        assert "EuclideanGeometry" not in _DIRECT_SYSTEM

    def test_supplement_would_be_appended_for_probability(self):
        """Simulate what translate_direct does: detect + load supplement."""
        item = _make_item(section="Probability Theory")
        cat_file = detect_math_category(item)
        supplement = _load_category_supplement(cat_file)
        system_parts = [_DIRECT_SYSTEM]
        if supplement:
            system_parts.append(supplement)
        system = "\n\n".join(system_parts)
        assert "MeasureTheory" in system
        assert "ProbabilityTheory" in system
        # Base prompt content is preserved
        assert "Lean 4 expert" in system

    def test_supplement_would_be_appended_for_trig(self):
        item = _make_item(section="Trigonometry")
        cat_file = detect_math_category(item)
        supplement = _load_category_supplement(cat_file)
        system_parts = [_DIRECT_SYSTEM]
        if supplement:
            system_parts.append(supplement)
        system = "\n\n".join(system_parts)
        assert "Real.sin" in system
        assert "Real.cos" in system

    def test_no_supplement_for_unknown_category(self):
        item = _make_item(section="Uncategorized", statement="x = x")
        cat_file = detect_math_category(item)
        supplement = _load_category_supplement(cat_file)
        assert supplement == ""
        # System prompt is just the base
        system_parts = [_DIRECT_SYSTEM]
        if supplement:
            system_parts.append(supplement)
        system = "\n\n".join(system_parts)
        assert system == _DIRECT_SYSTEM
