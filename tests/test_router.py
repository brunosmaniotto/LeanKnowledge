from leanknowledge.router import Router
from leanknowledge.schemas import (
    ExtractedItem, StatementType, ClaimRole, Domain, LibrarianResult
)
from unittest.mock import MagicMock

def test_route_items(mock_backlog):
    # Mock librarian
    librarian = MagicMock()
    # Configure lookup to return "not found"
    librarian.lookup.return_value = LibrarianResult(
        query="...", found=False
    )
    
    router = Router(librarian, mock_backlog)
    
    item1 = ExtractedItem(id="Def1", type=StatementType.DEFINITION, statement="...", section="1")
    item2 = ExtractedItem(id="Thm1", type=StatementType.THEOREM, statement="...", section="1")
    
    router.route([item1, item2], Domain.ALGEBRA, "Source")
    
    assert "Def1" in mock_backlog.entries
    assert "Thm1" in mock_backlog.entries
    
    # Check roles/status
    # Definitions are added but usually not "READY" to be proved.
    # Backlog handles status. 
    # item1 type is DEFINITION -> SKIPPED in backlog default add_item logic?
    # Let's check backlog.add_item logic:
    # status = SKIPPED if item.type.value in NON_PROVABLE else PENDING

    # Definition is SKIPPED
    assert mock_backlog.entries["Def1"].status.value == "skipped"
    
    # Theorem with no deps becomes READY immediately after _refresh_statuses
    assert mock_backlog.entries["Thm1"].status.value == "ready"
