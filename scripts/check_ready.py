import sys
from pathlib import Path
sys.path.append(str(Path("src").resolve()))

from leanknowledge.backlog import Backlog
from leanknowledge.schemas import BacklogStatus

backlog = Backlog()
ready = backlog.get_ready()
ready.sort(key=lambda e: e.priority_score, reverse=True)

print(f"Found {len(ready)} READY items.")
for entry in ready[:10]:
    print(f"- {entry.item.id} (p={entry.priority_score})")
