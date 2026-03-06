"""
Analyze the MERGED citation graph to find top nodes and generate new seeds.
"""

import json
from pathlib import Path
from collections import Counter

def find_top_seeds():
    data_dir = Path("citation_graph/data")
    edges_file = data_dir / "merged_edges.json"
    papers_file = data_dir / "merged_papers.json"
    
    print("Loading merged graph...")
    edges = json.loads(edges_file.read_text())
    papers = json.loads(papers_file.read_text())
    
    # Calculate In-Degree (Citation Count within our graph)
    in_degree = Counter()
    for citer_id, cited_list in edges.items():
        for cited_id in cited_list:
            in_degree[cited_id] += 1
            
    # Get Top 500
    top_nodes = in_degree.most_common(500)
    
    print(f"\nTop 10 Nodes by Internal Citation Count:")
    for rank, (pid, count) in enumerate(top_nodes[:10], 1):
        title = papers.get(pid, {}).get("title", "Unknown Title")
        print(f"{rank}. {title} ({count} cites) - {pid}")
        
    # Filter for OpenAlex IDs only (since we are restarting the OA builder)
    oa_queue = [pid for pid, _ in top_nodes if papers[pid].get("source") == "oa"]
    
    queue_file = data_dir / "oa_queue.json"
    queue_file.write_text(json.dumps(oa_queue, indent=2))
    print(f"\nSaved {len(oa_queue)} top OA nodes to {queue_file}")

if __name__ == "__main__":
    find_top_seeds()
