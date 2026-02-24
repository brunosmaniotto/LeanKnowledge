"""
Populate OA queue with unexpanded nodes from the merged graph.
"""

import json
from pathlib import Path

DATA_DIR = Path("citation_graph/data")

def update_queue():
    papers = json.loads((DATA_DIR / "merged_papers.json").read_text())
    edges = json.loads((DATA_DIR / "merged_edges.json").read_text())
    
    # Find nodes that appear in edges (as destination) but are not fully expanded
    # Actually, simpler: find nodes that are in 'papers' but don't have an entry in 'edges' (source)
    # This means we haven't fetched THEIR citations yet.
    
    # Note: papers keys are canonical IDs (S2 or OA)
    # We need to convert them back to OA IDs for the OA Builder
    # If it's an S2 ID, we can't easily query OA with it without mapping back.
    # So we only queue the OA-native IDs for now.
    
    queue = []
    
    print(f"Scanning {len(papers)} papers for unexpanded nodes...")
    for pid, p in papers.items():
        if p["source"] == "oa":
            if pid not in edges: # We haven't fetched who cites this
                queue.append(pid)
                
    print(f"Found {len(queue)} unexpanded OpenAlex nodes.")
    
    # Save to OA Queue
    (DATA_DIR / "oa_queue.json").write_text(json.dumps(queue, indent=2))
    print("OA Queue updated.")

if __name__ == "__main__":
    update_queue()
