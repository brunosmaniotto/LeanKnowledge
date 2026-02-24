"""Tests for Phase 2 infrastructure: citation suggestions, LLM gateway, Lean REPL, storage migration."""

import json
import pytest
from pathlib import Path
from unittest.mock import patch, MagicMock

from leanknowledge.citation_suggestions import CitationSuggester, PaperSuggestion
from leanknowledge.storage import BacklogStore, StrategyStore, init_db, migrate_json_to_sqlite
from leanknowledge.schemas import (
    BacklogEntry, ExtractedItem, StatementType, Domain, BacklogStatus,
)
from leanknowledge.strategy_kb import StrategyKB, StrategyEntry
from leanknowledge.backlog import Backlog


# ---------------------------------------------------------------------------
# Citation Suggestions
# ---------------------------------------------------------------------------

class TestCitationSuggester:
    @pytest.fixture
    def papers_dir(self, tmp_path):
        data_dir = tmp_path / "citation_graph" / "data"
        data_dir.mkdir(parents=True)
        papers = {
            "paper1": {
                "title": "Monotone Comparative Statics in Microeconomics",
                "abstract": "We study lattice-theoretic methods for preference relations and optimization.",
                "year": 1994,
                "venue": "Econometrica",
                "authors": ["Milgrom", "Shannon"],
            },
            "paper2": {
                "title": "Fixed Point Theorems in Game Theory",
                "abstract": "Kakutani fixed point theorem applied to Nash equilibrium existence.",
                "year": 1950,
                "venue": "Annals of Mathematics",
                "authors": ["Nash"],
            },
            "paper3": {
                "title": "Topology and Order",
                "abstract": "Connections between topological properties and ordered sets.",
                "year": 2000,
                "venue": "Journal of Mathematical Economics",
                "authors": ["Author"],
            },
        }
        (data_dir / "papers.json").write_text(json.dumps(papers))
        return data_dir

    def test_suggest_returns_relevant_papers(self, papers_dir):
        suggester = CitationSuggester(data_dir=papers_dir)
        results = suggester.suggest("preference relations and lattice methods")
        assert len(results) > 0
        assert results[0].title == "Monotone Comparative Statics in Microeconomics"

    def test_suggest_empty_query(self, papers_dir):
        suggester = CitationSuggester(data_dir=papers_dir)
        results = suggester.suggest("")
        assert results == []

    def test_suggest_no_matches(self, papers_dir):
        suggester = CitationSuggester(data_dir=papers_dir)
        results = suggester.suggest("zygomorphic functorial cohomology")
        assert results == []

    def test_suggest_respects_top_k(self, papers_dir):
        suggester = CitationSuggester(data_dir=papers_dir)
        results = suggester.suggest("theorem", top_k=1)
        assert len(results) <= 1

    def test_suggest_domain_boost(self, papers_dir):
        suggester = CitationSuggester(data_dir=papers_dir)
        results = suggester.suggest("comparative statics optimization", domain="microeconomics")
        if results:
            # Econometrica paper should get domain boost
            assert results[0].venue == "Econometrica"

    def test_missing_papers_file(self, tmp_path):
        suggester = CitationSuggester(data_dir=tmp_path / "nonexistent")
        results = suggester.suggest("anything")
        assert results == []

    def test_corrupt_papers_file(self, tmp_path):
        data_dir = tmp_path / "data"
        data_dir.mkdir()
        (data_dir / "papers.json").write_text("not json{{{")
        suggester = CitationSuggester(data_dir=data_dir)
        results = suggester.suggest("anything")
        assert results == []

    def test_paper_suggestion_fields(self, papers_dir):
        suggester = CitationSuggester(data_dir=papers_dir)
        results = suggester.suggest("Kakutani fixed point Nash equilibrium")
        assert len(results) > 0
        paper = results[0]
        assert isinstance(paper, PaperSuggestion)
        assert paper.year == 1950
        assert "Nash" in paper.authors
        assert 0 < paper.relevance_score <= 1.0


# ---------------------------------------------------------------------------
# LLM Gateway
# ---------------------------------------------------------------------------

class TestLLMGateway:
    def test_model_aliases(self):
        from leanknowledge.llm_gateway import MODEL_ALIASES
        assert "sonnet" in MODEL_ALIASES
        assert "haiku" in MODEL_ALIASES
        assert "deepseek" in MODEL_ALIASES

    def test_import_without_litellm(self):
        """Gateway should import cleanly even without litellm installed."""
        from leanknowledge.llm_gateway import HAS_LITELLM, call_llm
        # If litellm isn't installed, HAS_LITELLM should be False
        # and call_llm should raise ImportError
        if not HAS_LITELLM:
            with pytest.raises(ImportError, match="litellm"):
                call_llm("test prompt")

    def test_extract_json_from_fences(self):
        from leanknowledge.llm_gateway import _extract_json
        text = 'Here is the answer:\n```json\n{"key": "value"}\n```\nDone.'
        result = _extract_json(text)
        assert result == {"key": "value"}

    def test_extract_json_bare(self):
        from leanknowledge.llm_gateway import _extract_json
        text = 'Some text {"result": 42} more text'
        result = _extract_json(text)
        assert result == {"result": 42}

    def test_extract_json_invalid_raises(self):
        from leanknowledge.llm_gateway import _extract_json
        with pytest.raises(ValueError, match="Could not extract JSON"):
            _extract_json("no json here at all")


# ---------------------------------------------------------------------------
# Lean REPL
# ---------------------------------------------------------------------------

class TestLeanREPL:
    def test_init(self, tmp_path):
        from leanknowledge.lean.repl import LeanREPL
        repl = LeanREPL(project_dir=tmp_path)
        assert repl.project_dir == tmp_path
        assert repl._env_cache is None

    def test_invalidate_cache(self, tmp_path):
        from leanknowledge.lean.repl import LeanREPL
        repl = LeanREPL(project_dir=tmp_path)
        repl._env_cache = {"PATH": "/test"}
        repl._lean_path = "/some/path"
        repl._lean_src_path = "/some/src"
        repl.invalidate_cache()
        assert repl._env_cache is None
        assert repl._lean_path is None
        assert repl._lean_src_path is None

    @patch("subprocess.run")
    def test_ensure_env_caches_paths(self, mock_run, tmp_path):
        from leanknowledge.lean.repl import LeanREPL
        mock_run.return_value = MagicMock(
            returncode=0,
            stdout=json.dumps({
                "oleanPath": ["/path/to/oleans1", "/path/to/oleans2"],
                "srcPath": ["/path/to/src"],
            }),
        )
        repl = LeanREPL(project_dir=tmp_path)
        repl._ensure_env()
        assert repl._lean_path == "/path/to/oleans1:/path/to/oleans2"
        assert repl._lean_src_path == "/path/to/src"
        assert repl._env_cache is not None
        assert repl._env_cache["LEAN_PATH"] == "/path/to/oleans1:/path/to/oleans2"

    @patch("subprocess.run")
    def test_ensure_env_handles_failure(self, mock_run, tmp_path):
        from leanknowledge.lean.repl import LeanREPL
        mock_run.return_value = MagicMock(returncode=1, stdout="", stderr="error")
        repl = LeanREPL(project_dir=tmp_path)
        repl._ensure_env()
        # Should still have an env cache (just without LEAN_PATH)
        assert repl._env_cache is not None
        assert repl._lean_path is None

    @patch("subprocess.run")
    def test_compile_writes_scratch_file(self, mock_run, tmp_path):
        from leanknowledge.lean.repl import LeanREPL
        from leanknowledge.schemas import LeanCode

        # First call: lake env printPaths
        # Second call: lean Scratch.lean
        mock_run.side_effect = [
            MagicMock(returncode=0, stdout=json.dumps({"oleanPath": [], "srcPath": []})),
            MagicMock(returncode=0, stdout="", stderr=""),
        ]
        repl = LeanREPL(project_dir=tmp_path)
        code = LeanCode(code="theorem test : True := trivial", imports=["Mathlib.Tactic"])
        success, errors = repl.compile(code)
        assert success
        assert errors == []

        # Check that scratch file was written
        scratch = tmp_path / "LeanKnowledge" / "Scratch.lean"
        assert scratch.exists()
        content = scratch.read_text()
        assert "import Mathlib.Tactic" in content
        assert "theorem test : True := trivial" in content


# ---------------------------------------------------------------------------
# Storage: SQLite migration roundtrip
# ---------------------------------------------------------------------------

class TestSQLiteMigration:
    def test_migrate_backlog(self, tmp_path):
        """Full migration: write JSON backlog, migrate, verify SQLite has same data."""
        # Create a minimal backlog JSON
        item = ExtractedItem(id="thm1", type=StatementType.THEOREM, statement="x > 0", section="1.A")
        entry = BacklogEntry(item=item, source="test_source", domain=Domain.REAL_ANALYSIS)
        backlog_data = {"thm1": entry.model_dump(mode="json")}
        backlog_json = tmp_path / "backlog.json"
        backlog_json.write_text(json.dumps(backlog_data, indent=2, default=str))

        # Migrate
        db_path = tmp_path / "leanknowledge.db"
        migrate_json_to_sqlite(backlog_json=backlog_json, db_path=db_path)

        # Verify
        store = BacklogStore(db_path)
        loaded = store.load_all()
        assert "thm1" in loaded
        assert loaded["thm1"].item.statement == "x > 0"
        assert loaded["thm1"].domain == Domain.REAL_ANALYSIS

    def test_migrate_strategy_kb(self, tmp_path):
        """Migrate strategy KB JSON to SQLite and verify."""
        entries = [
            {
                "theorem_id": "thm1", "domain": "algebra",
                "mathematical_objects": ["group"], "proof_strategies": ["direct"],
                "lean_tactics_used": ["intro", "exact"], "lean_tactics_failed": [],
                "difficulty": "easy", "iterations_to_compile": 1, "proof_revisions": 0,
                "error_types_encountered": [], "dependencies_used": [], "source": "test"
            }
        ]
        kb_json = tmp_path / "strategy_kb.json"
        kb_json.write_text(json.dumps(entries))

        db_path = tmp_path / "leanknowledge.db"
        migrate_json_to_sqlite(strategy_json=kb_json, db_path=db_path)

        store = StrategyStore(db_path)
        loaded = store.load_all()
        assert len(loaded) == 1
        assert loaded[0].theorem_id == "thm1"
        assert loaded[0].lean_tactics_used == ["intro", "exact"]

    def test_backlog_upsert_overwrites(self, tmp_path):
        """Verify upsert replaces existing entry."""
        db_path = tmp_path / "test.db"
        store = BacklogStore(db_path)
        item = ExtractedItem(id="t1", type=StatementType.THEOREM, statement="original", section="1")
        entry = BacklogEntry(item=item, source="s", domain=Domain.ALGEBRA)
        store.upsert("t1", entry)

        # Update
        entry.status = BacklogStatus.COMPLETED
        store.upsert("t1", entry)

        loaded = store.load_all()
        assert loaded["t1"].status == BacklogStatus.COMPLETED

    def test_backlog_with_sqlite_active(self, tmp_path):
        """Verify Backlog class detects and uses SQLite when db exists."""
        # Create the db first
        db_path = tmp_path / "leanknowledge.db"
        init_db(db_path)

        # Create an empty backlog JSON
        backlog_path = tmp_path / "backlog.json"
        backlog_path.write_text("{}")

        backlog = Backlog(path=backlog_path)
        assert backlog._use_sqlite

    def test_strategy_kb_with_sqlite_loads(self, tmp_path):
        """Verify StrategyKB loads from SQLite when db exists but JSON doesn't."""
        db_path = tmp_path / "leanknowledge.db"
        store = StrategyStore(db_path)
        entry = StrategyEntry(
            theorem_id="thm_sql", domain="topology",
            mathematical_objects=["compact_set"], proof_strategies=["compactness"],
            lean_tactics_used=["apply"], lean_tactics_failed=[],
            difficulty="medium", iterations_to_compile=2, proof_revisions=0,
            error_types_encountered=["tactic_failure"], dependencies_used=[], source="test"
        )
        store.add(entry)

        # Load via StrategyKB (no JSON file, only SQLite)
        kb_path = tmp_path / "strategy_kb.json"  # doesn't exist
        kb = StrategyKB(path=kb_path)
        assert len(kb.entries) == 1
        assert kb.entries[0].theorem_id == "thm_sql"


# ---------------------------------------------------------------------------
# Backlog incremental saves
# ---------------------------------------------------------------------------

class TestBacklogIncrementalSave:
    def test_mark_in_progress_saves_entry(self, tmp_path):
        backlog_path = tmp_path / "backlog.json"
        backlog = Backlog(path=backlog_path)
        item = ExtractedItem(id="t1", type=StatementType.THEOREM, statement="test", section="1")
        backlog.add_item(item, source="s", domain=Domain.ALGEBRA)

        backlog.mark_in_progress("t1")
        assert backlog.entries["t1"].status == BacklogStatus.IN_PROGRESS
        assert backlog.entries["t1"].attempts == 1

        # Reload and verify persistence
        backlog2 = Backlog(path=backlog_path)
        assert backlog2.entries["t1"].status == BacklogStatus.IN_PROGRESS

    def test_mark_failed_saves_reason(self, tmp_path):
        backlog_path = tmp_path / "backlog.json"
        backlog = Backlog(path=backlog_path)
        item = ExtractedItem(id="t1", type=StatementType.THEOREM, statement="test", section="1")
        backlog.add_item(item, source="s", domain=Domain.ALGEBRA)
        backlog.mark_in_progress("t1")
        backlog.mark_failed("t1", reason="Kakutani needed")

        backlog2 = Backlog(path=backlog_path)
        assert backlog2.entries["t1"].status == BacklogStatus.FAILED
        assert backlog2.entries["t1"].failure_reason == "Kakutani needed"


# ---------------------------------------------------------------------------
# Strategy KB incremental save
# ---------------------------------------------------------------------------

class TestStrategyKBIncrementalSave:
    def test_add_persists_immediately(self, tmp_path):
        kb_path = tmp_path / "strategy_kb.json"
        kb = StrategyKB(path=kb_path)
        entry = StrategyEntry(
            theorem_id="t1", domain="algebra", mathematical_objects=["ring"],
            proof_strategies=["direct"], lean_tactics_used=["ring"],
            lean_tactics_failed=[], difficulty="easy", iterations_to_compile=1,
            proof_revisions=0, error_types_encountered=[], dependencies_used=[], source="test"
        )
        kb.add(entry)

        # Reload and verify
        kb2 = StrategyKB(path=kb_path)
        assert len(kb2.entries) == 1
        assert kb2.entries[0].theorem_id == "t1"

    def test_add_with_sqlite(self, tmp_path):
        """Verify add() writes to both JSON and SQLite."""
        db_path = tmp_path / "leanknowledge.db"
        init_db(db_path)
        kb_path = tmp_path / "strategy_kb.json"
        kb = StrategyKB(path=kb_path)

        entry = StrategyEntry(
            theorem_id="t1", domain="algebra", mathematical_objects=["ring"],
            proof_strategies=["direct"], lean_tactics_used=["ring"],
            lean_tactics_failed=[], difficulty="easy", iterations_to_compile=1,
            proof_revisions=0, error_types_encountered=[], dependencies_used=[], source="test"
        )
        kb.add(entry)

        # Verify JSON
        raw = json.loads(kb_path.read_text())
        assert len(raw) == 1

        # Verify SQLite
        store = StrategyStore(db_path)
        loaded = store.load_all()
        assert len(loaded) == 1
