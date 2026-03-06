"""Router — dispatches extracted claims to the appropriate pipeline path."""

from typing import List
from .schemas import ExtractedItem, ClaimRole, Domain, BacklogStatus
from .agents.librarian import LibrarianAgent
from .backlog import Backlog

class Router:
    def __init__(self, librarian: LibrarianAgent, backlog: Backlog):
        self.librarian = librarian
        self.backlog = backlog

    def route(self, items: List[ExtractedItem], domain: Domain, source: str):
        """Process a list of extracted items and dispatch them."""
        for item in items:
            print(f"  [router] Routing item: {item.id} ({item.role.value})")
            
            # 1. Ask the Librarian if it's already in Mathlib
            lib_res = self.librarian.lookup(item.statement)
            if lib_res.found:
                print(f"    -> Found in Mathlib: {lib_res.lean_name}")
                # Mark as resolved/skipped because it exists externally
                self.backlog.add_item(item, source, domain)
                self.backlog.mark_completed(item.id, lean_file=f"Mathlib:{lib_res.lean_name}")
                continue

            # 2. Handle by role
            if item.role == ClaimRole.DEFINITION:
                print(f"    -> Definition: sending to backlog (skipped)")
                self.backlog.add_item(item, source, domain)
                # Definitions are usually 'skipped' in formalization but tracked
            
            elif item.role == ClaimRole.CLAIMED_RESULT:
                print(f"    -> Claimed Result: queueing for formalization")
                self.backlog.add_item(item, source, domain)
                # Status will be PENDING -> READY depending on deps
            
            elif item.role in (ClaimRole.INVOKED_DEPENDENCY, ClaimRole.IMPLICIT_ASSUMPTION):
                print(f"    -> Dependency/Assumption: adding to backlog")
                self.backlog.add_item(item, source, domain)
                # These are taken as given for now
