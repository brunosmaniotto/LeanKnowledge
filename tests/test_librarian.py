"""Tests for Agent 4: Librarian deduplication gate."""

from unittest.mock import MagicMock

from leanknowledge.schemas import ExtractedItem, ExtractionResult, StatementType, ClaimRole
from leanknowledge.agents.triage import TriageAgent
from leanknowledge.agents.librarian import (
    LibrarianAgent, InMemoryLibrary, LoogleLibrary, StackedLibrary,
    RosettaStoneLibrary, MatchType, TFIDF_SCORE_SCALE,
)
from leanknowledge.loogle import LoogleClient, LoogleResult
from leanknowledge.mathlib_index import MathlibIndex, SearchResult


def _item(id: str, statement: str, type: StatementType = StatementType.THEOREM) -> ExtractedItem:
    return ExtractedItem(
        id=id, type=type, role=ClaimRole.CLAIMED_RESULT,
        statement=statement, section="1.A", labeled=True,
    )


def _make_inbox(items: list[ExtractedItem]):
    extraction = ExtractionResult(source="test", items=items)
    return TriageAgent().triage(extraction)


class TestLibrarian:
    def test_exact_match_skipped(self):
        lib = InMemoryLibrary()
        lib.add("Thm_1", "If X is compact and f is continuous, then f(X) is compact.",
                source="mathlib")

        inbox = _make_inbox([
            _item("Thm_1", "If X is compact and f is continuous, then f(X) is compact."),
        ])

        result = LibrarianAgent(lib).check(inbox)
        assert len(result.exact_matches) == 1
        assert len(result.to_backlog) == 0
        assert result.exact_matches[0].matched_source == "mathlib"

    def test_no_match_goes_to_backlog(self):
        lib = InMemoryLibrary()  # empty library

        inbox = _make_inbox([
            _item("Thm_1", "Every bounded sequence in R^n has a convergent subsequence."),
        ])

        result = LibrarianAgent(lib).check(inbox)
        assert len(result.no_matches) == 1
        assert len(result.to_backlog) == 1

    def test_partial_match_goes_to_backlog(self):
        """A related but not identical statement → partial match → backlog."""
        lib = InMemoryLibrary()
        lib.add("compact_image", "If f is continuous and K is compact, then f(K) is compact.",
                source="mathlib")

        inbox = _make_inbox([
            # Same idea, different wording + extra condition
            _item("Thm_1", "If f is continuous and K is compact in a metric space, then f(K) is compact and bounded."),
        ])

        result = LibrarianAgent(lib).check(inbox)
        assert len(result.to_backlog) == 1
        # Should be partial, not exact (the statements differ meaningfully)
        verdict = result.to_backlog[0]
        assert verdict.match_type in (MatchType.PARTIAL, MatchType.NONE)

    def test_definitions_also_checked(self):
        """Definitions go through the librarian too."""
        lib = InMemoryLibrary()
        lib.add("ContinuousOn", "A function f is continuous on S if ...",
                source="mathlib")

        inbox = _make_inbox([
            _item("Def_cont", "A function f is continuous on S if ...",
                  type=StatementType.DEFINITION),
        ])

        result = LibrarianAgent(lib).check(inbox)
        assert len(result.exact_matches) == 1

    def test_mixed_inbox(self):
        """Some items match, some don't."""
        lib = InMemoryLibrary()
        lib.add("reflexivity", "Completeness implies reflexivity.",
                source="knowledge_tree")

        inbox = _make_inbox([
            _item("Claim_1", "Completeness implies reflexivity."),
            _item("Thm_2", "The strict preference relation is transitive."),
            _item("Def_1", "A preference is rational if complete and transitive.",
                  type=StatementType.DEFINITION),
        ])

        result = LibrarianAgent(lib).check(inbox)
        assert len(result.exact_matches) == 1  # Claim_1
        assert len(result.to_backlog) == 2     # Thm_2 + Def_1

    def test_empty_library(self):
        lib = InMemoryLibrary()
        inbox = _make_inbox([
            _item("Thm_1", "Something new."),
            _item("Thm_2", "Something else new."),
        ])

        result = LibrarianAgent(lib).check(inbox)
        assert len(result.exact_matches) == 0
        assert len(result.to_backlog) == 2

    def test_empty_inbox(self):
        lib = InMemoryLibrary()
        lib.add("Thm_1", "Some theorem.", source="mathlib")

        inbox = _make_inbox([])
        result = LibrarianAgent(lib).check(inbox)
        assert len(result.to_backlog) == 0
        assert len(result.exact_matches) == 0


# ---------------------------------------------------------------------------
# LoogleLibrary tests (mock Loogle HTTP calls)
# ---------------------------------------------------------------------------

def _mock_loogle_client(hits: list[LoogleResult]) -> LoogleClient:
    """Create a mock LoogleClient that returns fixed hits."""
    client = MagicMock(spec=LoogleClient)
    client.search.return_value = hits
    client.search_by_type.return_value = hits
    return client


class TestLoogleLibrary:
    def test_no_hits_returns_empty(self):
        client = _mock_loogle_client([])
        lib = LoogleLibrary(client=client)
        results = lib.search("some random statement")
        assert results == []

    def test_hit_returns_result_with_similarity(self):
        client = _mock_loogle_client([
            LoogleResult(
                name="Nat.add_comm",
                type_sig="\u2200 (n m : \u2115), n + m = m + n",
                module="Mathlib.Data.Nat.Basic",
                doc="Addition is commutative",
            )
        ])
        lib = LoogleLibrary(client=client)
        results = lib.search("n + m = m + n")
        assert len(results) == 1
        assert results[0]["name"] == "Nat.add_comm"
        assert results[0]["source"] == "mathlib"
        assert results[0]["similarity"] >= 0.55  # minimum floor

    def test_similarity_floor(self):
        """Even a loosely matching Loogle hit gets at least 0.55 similarity."""
        client = _mock_loogle_client([
            LoogleResult(name="X.y.z", type_sig="totally different", module="M")
        ])
        lib = LoogleLibrary(client=client)
        results = lib.search("something unrelated")
        assert results[0]["similarity"] >= 0.55

    def test_name_matching_boosts_similarity(self):
        client = _mock_loogle_client([
            LoogleResult(name="Nat.add_comm", type_sig="...", module="M")
        ])
        lib = LoogleLibrary(client=client)
        results = lib.search("some statement", name="Nat.add_comm")
        # Name match should give high similarity
        assert results[0]["similarity"] > 0.8

    def test_client_failure_returns_empty(self):
        client = MagicMock(spec=LoogleClient)
        client.search.side_effect = RuntimeError("network down")
        lib = LoogleLibrary(client=client)
        results = lib.search("anything")
        assert results == []

    def test_loogle_library_with_librarian_agent(self):
        """Integration: LoogleLibrary plugs into LibrarianAgent correctly."""
        client = _mock_loogle_client([
            LoogleResult(
                name="Nat.add_comm",
                type_sig="\u2200 (n m : \u2115), n + m = m + n",
                module="Mathlib.Data.Nat.Basic",
            )
        ])
        lib = LoogleLibrary(client=client)
        inbox = _make_inbox([
            _item("Thm_1", "For all n m, n + m = m + n"),
        ])
        result = LibrarianAgent(lib).check(inbox)
        # Should register as at least partial match
        assert len(result.to_backlog) + len(result.exact_matches) == 1


# ---------------------------------------------------------------------------
# StackedLibrary tests
# ---------------------------------------------------------------------------

class TestStackedLibrary:
    def test_returns_first_strong_match(self):
        """First backend with a strong match wins; second backend not called."""
        backend1 = InMemoryLibrary()
        backend1.add("A", "Some theorem about primes.", source="mathlib")

        backend2 = InMemoryLibrary()
        backend2.add("B", "Some theorem about primes.", source="knowledge_tree")

        stacked = StackedLibrary([backend1, backend2])
        results = stacked.search("Some theorem about primes.")
        assert results[0]["name"] == "A"
        assert results[0]["source"] == "mathlib"

    def test_cascades_to_second_backend(self):
        """If first backend has no strong match, second backend is tried."""
        backend1 = InMemoryLibrary()  # empty — no matches
        backend2 = InMemoryLibrary()
        backend2.add("B", "Bolzano-Weierstrass theorem.", source="knowledge_tree")

        stacked = StackedLibrary([backend1, backend2])
        results = stacked.search("Bolzano-Weierstrass theorem.")
        assert len(results) > 0
        assert results[0]["name"] == "B"

    def test_all_empty_returns_empty(self):
        backend1 = InMemoryLibrary()
        backend2 = InMemoryLibrary()
        stacked = StackedLibrary([backend1, backend2])
        results = stacked.search("something novel")
        assert results == []

    def test_failing_backend_skipped(self):
        """If a backend raises, StackedLibrary logs and continues."""
        failing_backend = MagicMock()
        failing_backend.search.side_effect = RuntimeError("broken")

        good_backend = InMemoryLibrary()
        good_backend.add("C", "Good result.", source="mathlib")

        stacked = StackedLibrary([failing_backend, good_backend])
        results = stacked.search("Good result.")
        assert len(results) > 0
        assert results[0]["name"] == "C"

    def test_requires_at_least_one_backend(self):
        import pytest
        with pytest.raises(ValueError):
            StackedLibrary([])

    def test_stacked_with_loogle_and_inmemory(self):
        """Loogle first, InMemory second — realistic production setup."""
        loogle_client = _mock_loogle_client([
            LoogleResult(name="Real.sqrt_two_irrational", type_sig="...", module="M")
        ])
        loogle_lib = LoogleLibrary(client=loogle_client)

        inmem = InMemoryLibrary()
        inmem.add("my_sqrt2", "sqrt(2) is irrational", source="knowledge_tree")

        stacked = StackedLibrary([loogle_lib, inmem])
        results = stacked.search("sqrt(2) is irrational")
        # Loogle hit should come first (higher similarity due to floor)
        assert len(results) > 0
        assert results[0]["source"] == "mathlib"


# ---------------------------------------------------------------------------
# RosettaStoneLibrary tests
# ---------------------------------------------------------------------------

def _build_index(decls: list[dict]) -> MathlibIndex:
    """Build a small MathlibIndex for testing (TF-IDF only, no embeddings)."""
    idx = MathlibIndex(use_embeddings=False)
    idx.build_from_declarations(decls)
    return idx


class TestRosettaStoneLibrary:
    def test_search_returns_correct_format(self):
        """Results have the required dict keys: name, source, statement, similarity."""
        idx = _build_index([
            {"name": "Nat.add_comm", "signature": "∀ (n m : ℕ), n + m = m + n",
             "docstring": "Addition is commutative on natural numbers."},
        ])
        lib = RosettaStoneLibrary(idx)
        results = lib.search("commutativity of addition on natural numbers")
        assert len(results) >= 1
        r = results[0]
        assert set(r.keys()) == {"name", "source", "statement", "similarity"}
        assert r["name"] == "Nat.add_comm"
        assert r["source"] == "mathlib"
        assert isinstance(r["similarity"], float)

    def test_statement_field_prefers_signature(self):
        """When a declaration has a signature, it should be used as 'statement'."""
        idx = _build_index([
            {"name": "Nat.add_comm", "signature": "∀ (n m : ℕ), n + m = m + n",
             "docstring": "Addition is commutative."},
        ])
        lib = RosettaStoneLibrary(idx)
        results = lib.search("n + m = m + n")
        assert results[0]["statement"] == "∀ (n m : ℕ), n + m = m + n"

    def test_statement_field_falls_back_to_docstring(self):
        """When signature is empty, docstring is used as 'statement'."""
        idx = _build_index([
            {"name": "Nat.add_comm", "signature": "",
             "docstring": "Addition is commutative on natural numbers."},
        ])
        lib = RosettaStoneLibrary(idx)
        results = lib.search("addition commutative natural numbers")
        assert results[0]["statement"] == "Addition is commutative on natural numbers."

    def test_name_search_includes_extra_results(self):
        """Searching by name finds results that statement-only search might miss."""
        idx = _build_index([
            {"name": "Nat.add_comm", "signature": "∀ (n m : ℕ), n + m = m + n",
             "docstring": "Addition is commutative."},
            {"name": "Int.mul_comm", "signature": "∀ (a b : ℤ), a * b = b * a",
             "docstring": "Multiplication is commutative on integers."},
        ])
        lib = RosettaStoneLibrary(idx)
        # Statement about addition but name about multiplication
        results = lib.search("addition is commutative", name="Int.mul_comm")
        names = [r["name"] for r in results]
        # Both should appear since one matches the statement and the other the name
        assert "Nat.add_comm" in names
        assert "Int.mul_comm" in names

    def test_empty_index_returns_empty(self):
        """An empty MathlibIndex produces no results."""
        idx = MathlibIndex(use_embeddings=False)
        lib = RosettaStoneLibrary(idx)
        results = lib.search("anything at all")
        assert results == []

    def test_score_scaling(self):
        """TF-IDF scores are scaled up to match the Librarian's threshold range."""
        idx = _build_index([
            {"name": "Nat.add_comm", "signature": "∀ (n m : ℕ), n + m = m + n",
             "docstring": "Addition is commutative on natural numbers."},
        ])
        # Get raw TF-IDF score
        raw_results = idx.search("∀ (n m : ℕ), n + m = m + n", top_k=1)
        raw_score = raw_results[0].score

        lib = RosettaStoneLibrary(idx, score_scale=TFIDF_SCORE_SCALE)
        results = lib.search("∀ (n m : ℕ), n + m = m + n")
        scaled_score = results[0]["similarity"]

        expected = min(raw_score * TFIDF_SCORE_SCALE, 1.0)
        assert abs(scaled_score - expected) < 1e-9

    def test_score_capped_at_one(self):
        """Scaled scores must never exceed 1.0."""
        idx = _build_index([
            {"name": "X", "signature": "X", "docstring": "X"},
        ])
        # Use an extreme scale factor to force score > 1.0 before capping
        lib = RosettaStoneLibrary(idx, score_scale=100.0)
        results = lib.search("X")
        assert results[0]["similarity"] <= 1.0

    def test_deduplication_keeps_highest_score(self):
        """When statement + name queries return the same declaration, keep highest score."""
        idx = _build_index([
            {"name": "Nat.add_comm", "signature": "∀ (n m : ℕ), n + m = m + n",
             "docstring": "Addition is commutative."},
        ])
        lib = RosettaStoneLibrary(idx)
        # Both queries will match the same declaration
        results = lib.search("∀ (n m : ℕ), n + m = m + n", name="Nat.add_comm")
        # Should be deduplicated to a single entry
        names = [r["name"] for r in results]
        assert names.count("Nat.add_comm") == 1

    def test_results_sorted_by_similarity_descending(self):
        """Results are returned in descending similarity order."""
        idx = _build_index([
            {"name": "Nat.add_comm", "signature": "∀ (n m : ℕ), n + m = m + n",
             "docstring": "Addition is commutative on natural numbers."},
            {"name": "Nat.mul_comm", "signature": "∀ (n m : ℕ), n * m = m * n",
             "docstring": "Multiplication is commutative on natural numbers."},
            {"name": "List.reverse_reverse", "signature": "∀ (l : List α), l.reverse.reverse = l",
             "docstring": "Reversing a list twice gives the original."},
        ])
        lib = RosettaStoneLibrary(idx)
        results = lib.search("addition commutative natural numbers")
        sims = [r["similarity"] for r in results]
        assert sims == sorted(sims, reverse=True)

    def test_source_field_preserved_mathlib(self):
        """Mathlib declarations have source='mathlib'."""
        idx = _build_index([
            {"name": "Nat.add_comm", "signature": "sig", "docstring": "doc",
             "source": "mathlib"},
        ])
        lib = RosettaStoneLibrary(idx)
        results = lib.search("Nat add comm")
        assert results[0]["source"] == "mathlib"

    def test_source_field_preserved_rosetta(self):
        """Rosetta Stone entries have source='rosetta'."""
        idx = _build_index([
            {"name": "my_theorem", "signature": "proved theorem", "docstring": "my proof",
             "source": "rosetta"},
        ])
        lib = RosettaStoneLibrary(idx)
        results = lib.search("proved theorem my proof")
        assert results[0]["source"] == "rosetta"


# ---------------------------------------------------------------------------
# RosettaStoneLibrary + LibrarianAgent integration
# ---------------------------------------------------------------------------

class TestRosettaStoneLibraryIntegration:
    def test_exact_match_via_tfidf(self):
        """A near-identical statement in Mathlib → EXACT match."""
        idx = _build_index([
            {"name": "Nat.add_comm",
             "signature": "∀ (n m : ℕ), n + m = m + n",
             "docstring": "Addition is commutative on natural numbers."},
        ])
        lib = RosettaStoneLibrary(idx)
        inbox = _make_inbox([
            _item("Thm_1", "∀ (n m : ℕ), n + m = m + n"),
        ])
        result = LibrarianAgent(lib).check(inbox)
        # The TF-IDF score for a near-identical query should scale to ≥0.9
        assert len(result.exact_matches) == 1
        assert result.exact_matches[0].matched_name == "Nat.add_comm"

    def test_novel_item_no_match(self):
        """A completely unrelated statement → NO_MATCH."""
        idx = _build_index([
            {"name": "Nat.add_comm",
             "signature": "∀ (n m : ℕ), n + m = m + n",
             "docstring": "Addition is commutative."},
        ])
        lib = RosettaStoneLibrary(idx)
        inbox = _make_inbox([
            _item("Thm_1", "The category of compact Hausdorff spaces is complete."),
        ])
        result = LibrarianAgent(lib).check(inbox)
        assert len(result.no_matches) == 1

    def test_rosetta_entry_detected(self):
        """A Rosetta Stone entry (previously proved theorem) → match."""
        idx = _build_index([
            {"name": "pw/sum_of_cubes",
             "signature": "theorem sum_cubes (n : ℕ) : ...",
             "docstring": "The sum of the first n cubes equals the square of the sum.",
             "source": "rosetta"},
        ])
        lib = RosettaStoneLibrary(idx)
        inbox = _make_inbox([
            _item("Thm_1", "The sum of the first n cubes equals the square of the sum of the first n natural numbers."),
        ])
        result = LibrarianAgent(lib).check(inbox)
        # Should be at least a partial match
        all_matched = result.exact_matches + result.partial_matches
        assert len(all_matched) >= 1
        assert all_matched[0].matched_source == "rosetta"

    def test_pipeline_load_mathlib_index_upgrades_librarian(self):
        """After load_mathlib_index(), the librarian uses RosettaStoneLibrary."""
        from leanknowledge.pipeline import Pipeline

        pipeline = Pipeline()
        # Initially the librarian uses InMemoryLibrary
        assert isinstance(pipeline.librarian.library, InMemoryLibrary)

        # Create a small index and load it
        idx = _build_index([
            {"name": "Nat.add_comm",
             "signature": "∀ (n m : ℕ), n + m = m + n",
             "docstring": "Addition is commutative."},
        ])
        pipeline.mathlib_index = idx
        pipeline.translator.mathlib_index = idx
        pipeline.translator.pre_compiler._index = idx

        # Simulate the upgrade that load_mathlib_index does (without file I/O)
        rosetta_lib = RosettaStoneLibrary(idx)
        pipeline.librarian = LibrarianAgent(
            StackedLibrary([rosetta_lib, pipeline.librarian.library])
        )

        # Now verify the stacked library works
        assert isinstance(pipeline.librarian.library, StackedLibrary)
        inbox = _make_inbox([
            _item("Thm_1", "∀ (n m : ℕ), n + m = m + n"),
        ])
        result = pipeline.librarian.check(inbox)
        assert len(result.exact_matches) == 1
