import sys
from pathlib import Path
sys.path.append(str(Path("src").resolve()))

from leanknowledge.backlog import Backlog

backlog = Backlog()
item_id = "Proposition 4.C.2"
entry = backlog.get_entry(item_id)

if entry:
    print(f"SOURCE: {entry.source}")
else:
    print(f"Item {item_id} not found.")
