import pytest
from leanknowledge.schemas import (
    ExtractedItem, StatementType, Domain, BacklogStatus, ClaimRole
)
from leanknowledge.backlog import Backlog

def create_item(id, type=StatementType.THEOREM, deps=None, role=ClaimRole.CLAIMED_RESULT):
    return ExtractedItem(
        id=id,
        type=type,
        role=role,
        statement=f"Statement of {id}",
        section="1",
        dependencies=deps or []
    )

def test_add_item(mock_backlog):
    item = create_item("T1")
    is_new = mock_backlog.add_item(item, "Source", Domain.ALGEBRA)
    assert is_new is True
    assert "T1" in mock_backlog.entries
    
    # Adding again should return False
    is_new_again = mock_backlog.add_item(item, "Source", Domain.ALGEBRA)
    assert is_new_again is False

def test_dependency_resolution(mock_backlog):
    # T1 depends on T2
    t1 = create_item("T1", deps=["T2"])
    t2 = create_item("T2") # T2 has no deps
    
    mock_backlog.add_item(t1, "Source", Domain.ALGEBRA)
    mock_backlog.add_item(t2, "Source", Domain.ALGEBRA)
    
    # Initially both pending (or skipped if definition etc, but here theorem)
    # _refresh_statuses is called on add
    
    # T2 should be READY (no deps)
    # T1 should be BLOCKED (T2 is PENDING)
    
    e2 = mock_backlog.get_entry("T2")
    assert e2.status == BacklogStatus.READY
    
    e1 = mock_backlog.get_entry("T1")
    assert e1.status == BacklogStatus.BLOCKED
    
    # Complete T2
    mock_backlog.mark_completed("T2")
    
    # Now T1 should be READY
    e1 = mock_backlog.get_entry("T1")
    assert e1.status == BacklogStatus.READY

def test_priority_score(mock_backlog):
    # T1 -> T2 -> T3 (T1 depends on T2, T2 depends on T3)
    # So T3 blocks T2, T2 blocks T1.
    # T3 is needed by T2. T2 is needed by T1.
    # Priority score = count of dependents?
    # Logic in backlog.py:
    # for entry in self.entries.values():
    #     for dep in entry.item.dependencies:
    #         if dep in self.entries:
    #             self.entries[dep].priority_score += 1
    
    t1 = create_item("T1", deps=["T2"])
    t2 = create_item("T2", deps=["T3"])
    t3 = create_item("T3")
    
    mock_backlog.add_item(t1, "S", Domain.ALGEBRA)
    mock_backlog.add_item(t2, "S", Domain.ALGEBRA)
    mock_backlog.add_item(t3, "S", Domain.ALGEBRA)
    
    # T1 depends on T2 -> T2 gets +1
    # T2 depends on T3 -> T3 gets +1
    
    assert mock_backlog.get_entry("T1").priority_score == 0
    assert mock_backlog.get_entry("T2").priority_score == 1
    assert mock_backlog.get_entry("T3").priority_score == 1 
    # Wait, T3 is a dependency of T2. T2 is a dependency of T1.
    # Implementation counts direct dependents. 
    # Let's check T3. It is a dependency for T2. So T2 increases T3's score.
    # Let's verify with a diamond: T4 depends on T3.
    
    t4 = create_item("T4", deps=["T3"])
    mock_backlog.add_item(t4, "S", Domain.ALGEBRA)
    
    # Now T3 is needed by T2 and T4. Score should be 2.
    assert mock_backlog.get_entry("T3").priority_score == 2

def test_persistence(mock_backlog):
    item = create_item("T1")
    mock_backlog.add_item(item, "S", Domain.ALGEBRA)
    mock_backlog.mark_completed("T1")
    
    # Reload from same file
    new_backlog = Backlog(path=mock_backlog.path)
    assert "T1" in new_backlog.entries
    assert new_backlog.entries["T1"].status == BacklogStatus.COMPLETED

def test_get_feedable(mock_backlog):
    # Setup blocking dependency
    missing = create_item("Missing")
    mock_backlog.add_item(missing, "S", Domain.ALGEBRA)
    # Ensure "Missing" is PENDING (default) so dependents are BLOCKED
    
    # Setup entries
    # E1: Blocked, Dependency, Unreferenced -> Feedable
    # To be blocked, it needs an unresolved dependency. Let's say "Missing".
    e1 = create_item("E1", deps=["Missing"], role=ClaimRole.INVOKED_DEPENDENCY)
    mock_backlog.add_item(e1, "S", Domain.ALGEBRA)
    
    # E2: Blocked, Claimed Result, Referenced -> Feedable
    e2 = create_item("E2", deps=["Missing"], role=ClaimRole.CLAIMED_RESULT)
    mock_backlog.add_item(e2, "S", Domain.ALGEBRA)
    mock_backlog.entries["E2"].category = "referenced"
    
    # E3: Blocked, Claimed Result, Unreferenced -> Not Feedable
    e3 = create_item("E3", deps=["Missing"], role=ClaimRole.CLAIMED_RESULT)
    mock_backlog.add_item(e3, "S", Domain.ALGEBRA)
    mock_backlog.entries["E3"].category = "unreferenced"
    
    # E4: Ready -> Not Feedable
    # No deps -> Ready
    e4 = create_item("E4", role=ClaimRole.INVOKED_DEPENDENCY)
    mock_backlog.add_item(e4, "S", Domain.ALGEBRA)
    
    # E5: Blocked, Attempts > 2 -> Not Feedable
    e5 = create_item("E5", deps=["Missing"], role=ClaimRole.INVOKED_DEPENDENCY)
    mock_backlog.add_item(e5, "S", Domain.ALGEBRA)
    mock_backlog.entries["E5"].attempts = 3
    
    # Force refresh just in case (add_item does it, but we modified fields manually)
    mock_backlog._refresh_statuses()
    # Note: manual modification of category/attempts persists in memory
    
    feedable = mock_backlog.get_feedable()
    ids = [e.item.id for e in feedable]
    
    assert "E1" in ids
    assert "E2" in ids
    assert "E3" not in ids
    assert "E4" not in ids
    assert "E5" not in ids
    
    # Sorting check:
    # E2 is "referenced" (rank 0), E1 is "unreferenced" (rank 2).
    # Both have priority 0 (no dependents).
    # E2 should come before E1.
    assert ids == ["E2", "E1"]
