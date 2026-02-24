import sys
from pathlib import Path
sys.path.append(str(Path("src").resolve()))

from leanknowledge.backlog import Backlog

backlog = Backlog()
item_id = "Proposition 4.C.2"
entry = backlog.get_entry(item_id)

if entry:
    print(f"NAME: {entry.item.id}")
    print(f"DOMAIN: {entry.domain.value}")
    print(f"STATEMENT: {entry.item.statement}")
else:
    print(f"Item {item_id} not found.")
