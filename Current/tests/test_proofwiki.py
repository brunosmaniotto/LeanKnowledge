"""Tests for the ProofWiki adapter."""

import json
import pytest

from leanknowledge.proofwiki import (
    load_proofwiki,
    dataset_stats,
    _clean_wiki_markup,
    _classify_label,
    _theorem_to_item,
)
from leanknowledge.schemas import StatementType, ClaimRole


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

SAMPLE_DATASET = {
    "dataset": {
        "theorems": [
            {
                "id": 1,
                "label": "Sum of Two Even Numbers is Even",
                "contents": [
                    "Let $a, b \\in \\Z$ be [[Definition:Even Integer|even integers]].",
                    "Then $a + b$ is even.",
                ],
                                "proofs": [
                    {
                        "contents": [
                            "Since $a$ is even, $a = 2k$ for some $k \\in \\Z$.",
                            "Since $b$ is even, $b = 2m$ for some $m \\in \\Z$.",
                            "Then $a + b = 2(k + m)$, which is even.",
                        ],
                        "refs": [100],
                    }
                ],
                "categories": ["Number Theory"],
                "toplevel_categories": ["Number Theory"],
            },
            {
                "id": 2,
                "label": "Compact Subspace of Hausdorff Space is Closed",
                "contents": [
                    "Let $T = \\langle S, \\tau \\rangle$ be a [[Definition:Hausdorff Space|Hausdorff space]].",
                    "Let $C$ be a compact subspace of $T$.",
                    "Then $C$ is closed in $T$.",
                ],
                                "proofs": [
                    {
                        "contents": [
                            "Let $x \\in S \\setminus C$.",
                            "For each $c \\in C$, there exist disjoint open sets...",
                        ],
                        "refs": [100, 200],
                    }
                ],
                "categories": ["Topology"],
                "toplevel_categories": ["Topology"],
            },
            {
                "id": 3,
                "label": "Fermat's Little Theorem",
                "contents": ["If $p$ is prime and $\\gcd(a,p)=1$, then $a^{p-1} \\equiv 1 \\pmod{p}$."],
                                "proofs": [],
                "categories": ["Number Theory"],
                "toplevel_categories": ["Number Theory"],
            },
            {
                "id": 4,
                "label": "Lemma for Bezout's Identity",
                "contents": ["A helper result."],
                                "proofs": [{"contents": ["Straightforward."], "refs": []}],
                "categories": ["Number Theory"],
                "toplevel_categories": ["Number Theory"],
            },
        ],
        "definitions": [
            {
                "id": 100,
                "label": "Definition:Even Integer",
                "contents": ["An integer $n$ is even if $n = 2k$ for some integer $k$."],
            },
            {
                "id": 200,
                "label": "Definition:Hausdorff Space",
                "contents": ["A topological space where distinct points have disjoint neighborhoods."],
            },
        ],
        "others": [],
    }
}


@pytest.fixture
def sample_json(tmp_path):
    path = tmp_path / "proofwiki.json"
    path.write_text(json.dumps(SAMPLE_DATASET))
    return path


# ---------------------------------------------------------------------------
# Wiki markup cleaning
# ---------------------------------------------------------------------------

class TestCleanMarkup:
    def test_wiki_links_display_text(self):
        result = _clean_wiki_markup(["[[Definition:Even Integer|even integers]]"])
        assert result == "even integers"

    def test_wiki_links_no_pipe(self):
        result = _clean_wiki_markup(["[[Topology]]"])
        assert result == "Topology"

    def test_templates_removed(self):
        result = _clean_wiki_markup(["{{stub}}", "Some text"])
        assert "stub" not in result
        assert "Some text" in result

    def test_html_tags_removed(self):
        result = _clean_wiki_markup(["<ref name='foo'>citation</ref>rest"])
        assert "citation" not in result
        assert "rest" in result

    def test_multiple_lines_joined(self):
        result = _clean_wiki_markup(["Line 1.", "Line 2."])
        assert "Line 1." in result
        assert "Line 2." in result


# ---------------------------------------------------------------------------
# Label classification
# ---------------------------------------------------------------------------

class TestClassifyLabel:
    def test_theorem(self):
        assert _classify_label("Sum of Two Even Numbers is Even") == StatementType.THEOREM

    def test_lemma(self):
        assert _classify_label("Lemma for Bezout's Identity") == StatementType.LEMMA

    def test_corollary(self):
        assert _classify_label("Corollary to Rolle's Theorem") == StatementType.COROLLARY

    def test_definition(self):
        assert _classify_label("Definition:Even Integer") == StatementType.DEFINITION

    def test_proposition(self):
        assert _classify_label("Proposition 3.14") == StatementType.PROPOSITION


# ---------------------------------------------------------------------------
# Theorem → ExtractedItem
# ---------------------------------------------------------------------------

class TestTheoremToItem:
    def test_basic_conversion(self):
        entry = SAMPLE_DATASET["dataset"]["theorems"][0]
        item = _theorem_to_item(entry)

        assert item.id == "Sum of Two Even Numbers is Even"
        assert item.type == StatementType.THEOREM
        assert item.role == ClaimRole.CLAIMED_RESULT
        assert "even" in item.statement.lower()
        assert item.proof is not None
        assert "2k" in item.proof

    def test_dependencies_resolved_to_labels(self):
        entry = SAMPLE_DATASET["dataset"]["theorems"][0]
        def_lookup = {100: "Definition:Even Integer"}
        item = _theorem_to_item(entry, def_lookup)

        assert "Definition:Even Integer" in item.dependencies

    def test_no_proof_entry(self):
        entry = SAMPLE_DATASET["dataset"]["theorems"][2]  # Fermat's — no proof
        item = _theorem_to_item(entry)

        assert item.proof is None

    def test_category_as_section(self):
        entry = SAMPLE_DATASET["dataset"]["theorems"][1]
        item = _theorem_to_item(entry)

        assert item.section == "Topology"

    def test_lemma_type(self):
        entry = SAMPLE_DATASET["dataset"]["theorems"][3]
        item = _theorem_to_item(entry)
        assert item.type == StatementType.LEMMA


# ---------------------------------------------------------------------------
# load_proofwiki
# ---------------------------------------------------------------------------

class TestLoadProofwiki:
    def test_loads_with_proof_only(self, sample_json):
        items = load_proofwiki(sample_json, with_proof_only=True)
        # Fermat's has no proof, so 3 items
        assert len(items) == 3
        ids = {i.id for i in items}
        assert "Fermat's Little Theorem" not in ids

    def test_loads_all(self, sample_json):
        items = load_proofwiki(sample_json, with_proof_only=False)
        assert len(items) == 4

    def test_category_filter(self, sample_json):
        items = load_proofwiki(sample_json, categories=["Topology"])
        assert len(items) == 1
        assert items[0].id == "Compact Subspace of Hausdorff Space is Closed"

    def test_category_filter_case_insensitive(self, sample_json):
        items = load_proofwiki(sample_json, categories=["number theory"])
        assert len(items) == 2  # Sum + Lemma (Fermat has no proof)

    def test_max_items(self, sample_json):
        items = load_proofwiki(sample_json, max_items=1)
        assert len(items) == 1

    def test_dependencies_use_labels(self, sample_json):
        items = load_proofwiki(sample_json)
        sum_item = next(i for i in items if "Sum" in i.id)
        assert "Definition:Even Integer" in sum_item.dependencies


# ---------------------------------------------------------------------------
# dataset_stats
# ---------------------------------------------------------------------------

class TestDatasetStats:
    def test_stats(self, sample_json):
        stats = dataset_stats(sample_json)
        assert stats["theorems"] == 4
        assert stats["with_proof"] == 3
        assert stats["definitions"] == 2
