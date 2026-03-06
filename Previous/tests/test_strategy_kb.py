from leanknowledge.strategy_kb import StrategyEntry

def test_add_query(mock_strategy_kb):
    entry = StrategyEntry(
        theorem_id="T1",
        domain="algebra",
        mathematical_objects=["group", "homomorphism"],
        proof_strategies=["direct"],
        lean_tactics_used=["intro", "rw"],
        lean_tactics_failed=[],
        difficulty="easy",
        iterations_to_compile=1,
        proof_revisions=0,
        error_types_encountered=[],
        dependencies_used=[],
        source="book"
    )
    
    mock_strategy_kb.add(entry)
    
    # Query by object
    results = mock_strategy_kb.query_by_objects(["group"])
    assert len(results) == 1
    assert results[0].theorem_id == "T1"
    
    # Query by strategy
    results = mock_strategy_kb.query_by_strategy("direct")
    assert len(results) == 1
    
    # Query by unknown object
    results = mock_strategy_kb.query_by_objects(["topology"])
    assert len(results) == 0

def test_success_rates(mock_strategy_kb):
    # Add two entries for "group", one easy, one hard
    e1 = StrategyEntry(
        theorem_id="T1", domain="algebra", mathematical_objects=["group"],
        proof_strategies=["direct"], lean_tactics_used=[], lean_tactics_failed=[],
        difficulty="easy", iterations_to_compile=1, proof_revisions=0,
        error_types_encountered=[], dependencies_used=[], source="book"
    )
    e2 = StrategyEntry(
        theorem_id="T2", domain="algebra", mathematical_objects=["group"],
        proof_strategies=["direct"], lean_tactics_used=[], lean_tactics_failed=[],
        difficulty="hard", iterations_to_compile=5, proof_revisions=0,
        error_types_encountered=[], dependencies_used=[], source="book"
    )
    
    mock_strategy_kb.add(e1)
    mock_strategy_kb.add(e2)
    
    rates = mock_strategy_kb.strategy_success_rates(["group"])
    # 1 success (<=3 iters), 1 failure (>3 iters) for "direct"
    # Rate = 1/2 = 0.5
    assert rates["direct"] == 0.5
