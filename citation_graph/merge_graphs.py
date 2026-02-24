"""
Merge OpenAlex and Semantic Scholar graphs into a single canonical dataset.
"""

import json
from pathlib import Path
from typing import Dict, Set

DATA_DIR = Path("citation_graph/data")

def normalize_title(title: str) -> str:
    if not title: return ""
    return title.lower().strip().replace(":", "").replace("-", " ")

def merge_graphs():
    print("Loading datasets...")
    
    # Load OA
    oa_papers = json.loads((DATA_DIR / "oa_papers.json").read_text())
    oa_edges = json.loads((DATA_DIR / "oa_edges.json").read_text())
    
    # Load S2
    s2_papers = json.loads((DATA_DIR / "s2_papers.json").read_text())
    s2_edges = json.loads((DATA_DIR / "s2_edges.json").read_text())
    
    merged_papers = {}
    merged_edges = {}
    
    # Map Titles to Canonical IDs
    # We will use S2 IDs as canonical if available, else OA IDs
    title_to_id = {}
    
    print(f"Merging {len(s2_papers)} S2 papers and {len(oa_papers)} OA papers...")
    
    # 1. Process S2 (High Priority)
    for pid, p in s2_papers.items():
        norm_title = normalize_title(p.get("title"))
        if not norm_title: continue
        
        title_to_id[norm_title] = pid
        merged_papers[pid] = {
            "source": "s2",
            "title": p.get("title"),
            "year": p.get("year"),
            "venue": p.get("venue"),
            "citations": p.get("citationCount")
        }
        
    # 2. Process OA (Fill gaps)
    for pid, p in oa_papers.items():
        norm_title = normalize_title(p.get("title"))
        if not norm_title: continue
        
        if norm_title in title_to_id:
            # Already have this paper from S2, verify/enrich?
            # We skip for now, trusting S2
            continue
        else:
            # New paper found only in OA
            title_to_id[norm_title] = pid
            merged_papers[pid] = {
                "source": "oa",
                "title": p.get("title"),
                "year": p.get("year"),
                "venue": p.get("journal"),
                "citations": p.get("citations")
            }

    print(f"Total Unique Papers: {len(merged_papers)}")
    
    # 3. Merge Edges
    # We need to translate all IDs to the canonical IDs we just established
    # This is tricky because OA edges use OA IDs, S2 edges use S2 IDs.
    # We need a reverse map for the OA IDs that got merged into S2 IDs.
    
    # Build ID Map: {Original_ID -> Canonical_ID}
    id_map = {}
    
    # S2 IDs map to themselves
    for pid in s2_papers:
        id_map[pid] = pid
        
    # OA IDs map to S2 ID if title match, else self
    for pid, p in oa_papers.items():
        norm_title = normalize_title(p.get("title"))
        if norm_title in title_to_id:
            id_map[pid] = title_to_id[norm_title]
    
    print("Merging edges...")
    edge_count = 0
    
    def add_edge(src, dst):
        nonlocal edge_count
        canon_src = id_map.get(src)
        canon_dst = id_map.get(dst)
        
        if canon_src and canon_dst:
            if canon_src not in merged_edges:
                merged_edges[canon_src] = []
            if canon_dst not in merged_edges[canon_src]:
                merged_edges[canon_src].append(canon_dst)
                edge_count += 1

    # Process S2 Edges
    for src, dsts in s2_edges.items():
        for dst in dsts:
            add_edge(src, dst)
            
    # Process OA Edges
    for src, dsts in oa_edges.items():
        for dst in dsts:
            add_edge(src, dst)
            
    print(f"Total Unique Edges: {edge_count}")
    
    # Save
    (DATA_DIR / "merged_papers.json").write_text(json.dumps(merged_papers, indent=2))
    (DATA_DIR / "merged_edges.json").write_text(json.dumps(merged_edges, indent=2))
    print("Merged graph saved.")

if __name__ == "__main__":
    merge_graphs()
