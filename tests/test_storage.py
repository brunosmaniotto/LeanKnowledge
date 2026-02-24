import pytest
from pathlib import Path
from leanknowledge.storage import BacklogStore, StrategyStore, init_db
from leanknowledge.schemas import BacklogEntry, ExtractedItem, StatementType, ClaimRole, Domain, BacklogStatus
from leanknowledge.strategy_kb import StrategyEntry

@pytest.fixture
def db_path(tmp_path):
    return tmp_path / "test.db"

def test_backlog_store_roundtrip(db_path):
    store = BacklogStore(db_path)
    item = ExtractedItem(id="test_1", type=StatementType.THEOREM, statement="x > 0", section="1.A")
    entry = BacklogEntry(item=item, source="test", domain=Domain.REAL_ANALYSIS)
    store.upsert("test_1", entry)
    loaded = store.load_all()
    assert "test_1" in loaded
    assert loaded["test_1"].item.statement == "x > 0"

def test_strategy_store_roundtrip(db_path):
    store = StrategyStore(db_path)
    entry = StrategyEntry(
        theorem_id="thm1", domain="real_analysis", mathematical_objects=["set"],
        proof_strategies=["direct"], lean_tactics_used=["intro"], lean_tactics_failed=[],
        difficulty="easy", iterations_to_compile=1, proof_revisions=0,
        error_types_encountered=[], dependencies_used=[], source="test"
    )
    store.add(entry)
    loaded = store.load_all()
    assert len(loaded) == 1
    assert loaded[0].theorem_id == "thm1"

def test_count_by_status(db_path):
    store = BacklogStore(db_path)
    item1 = ExtractedItem(id="t1", type=StatementType.THEOREM, statement="a", section="1")
    item2 = ExtractedItem(id="t2", type=StatementType.THEOREM, statement="b", section="1")
    store.upsert("t1", BacklogEntry(item=item1, source="s", domain=Domain.ALGEBRA, status=BacklogStatus.READY))
    store.upsert("t2", BacklogEntry(item=item2, source="s", domain=Domain.ALGEBRA, status=BacklogStatus.COMPLETED))
    counts = store.count_by_status()
    assert counts["ready"] == 1
    assert counts["completed"] == 1
