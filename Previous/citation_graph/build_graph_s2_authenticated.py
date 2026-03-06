"""
Semantic Scholar Authenticated Graph Builder.

Uses the 'paper/batch' endpoint to fetch details for up to 500 papers at once.
Optimized for the 1 RPS authenticated rate limit.
"""

import time
import requests
import json
from pathlib import Path
from typing import List, Dict, Set

API_KEY = "MrFq2T4RvDaFibagnzP0V2YrcSh7V3P38HBZGXnv"
DATA_DIR = Path("citation_graph/data")
QUEUE_FILE = DATA_DIR / "s2_queue.json"
PAPERS_FILE = DATA_DIR / "s2_papers.json"
EDGES_FILE = DATA_DIR / "s2_edges.json"

TARGET_JOURNALS = {
    "American Economic Review", "The American Economic Review",
    "Econometrica",
    "Journal of Political Economy", "The Journal of Political Economy",
    "Quarterly Journal of Economics", "The Quarterly Journal of Economics",
    "Review of Economic Studies", "The Review of Economic Studies",
    "Journal of Economic Theory",
    "Games and Economic Behavior",
    "Theoretical Economics",
    "International Journal of Game Theory",
    "Journal of Mathematical Economics"
}

class S2GraphBuilder:
    def __init__(self):
        self.headers = {"x-api-key": API_KEY}
        self.queue = self._load_queue()
        self.papers = self._load_json(PAPERS_FILE)
        self.edges = self._load_json(EDGES_FILE)
        self.processed = set(self.papers.keys())

    def _load_json(self, path: Path) -> Dict:
        if path.exists():
            return json.loads(path.read_text())
        return {}

    def _load_queue(self) -> List[str]:
        if QUEUE_FILE.exists():
            return json.loads(QUEUE_FILE.read_text())
        return []

    def save(self):
        print(f"  [Save] {len(self.papers)} papers, {len(self.edges)} edges.")
        PAPERS_FILE.write_text(json.dumps(self.papers, indent=2))
        EDGES_FILE.write_text(json.dumps(self.edges, indent=2))
        QUEUE_FILE.write_text(json.dumps(self.queue, indent=2))

    def is_target_journal(self, venue: str) -> bool:
        return venue in TARGET_JOURNALS

    def run(self):
        print(f"=== Starting S2 Authenticated Builder (Queue: {len(self.queue)}) ===")
        
        while self.queue:
            # S2 Batch API allows requesting multiple IDs, but `citations` field 
            # returns ALL citations for EACH paper, which might be huge payload.
            # We process one-by-one to manage memory and pagination if needed,
            # but we can use the batch endpoint for metadata fetching if we had a list of unknown IDs.
            # Since our queue contains IDs we want to EXPAND (find citations OF), 
            # we must query them individually.
            
            current_id = self.queue.pop(0)
            if current_id in self.processed:
                continue
                
            self.expand_node(current_id)
            self.processed.add(current_id)
            
            if len(self.processed) % 50 == 0:
                self.save()
                
        self.save()
        print("=== Queue Empty ===")

    def expand_node(self, paper_id: str):
        # We need: title, year, venue, citations.paperId, citations.venue, citations.year
        fields = "title,year,venue,citationCount,citations.paperId,citations.title,citations.year,citations.venue"
        
        url = f"https://api.semanticscholar.org/graph/v1/paper/{paper_id}"
        
        try:
            resp = requests.get(url, headers=self.headers, params={"fields": fields, "limit": 1000}, timeout=10)
            
            if resp.status_code == 200:
                data = resp.json()
                self._process_data(paper_id, data)
            elif resp.status_code == 429:
                print("  [API] 429. Sleeping 5s...")
                self.queue.insert(0, paper_id) # Retry
                time.sleep(5)
            else:
                print(f"  [API] Error {resp.status_code} for {paper_id}")
                
            time.sleep(1.1) # 1 RPS limit
            
        except Exception as e:
            print(f"  [API] Exception: {e}")
            self.queue.insert(0, paper_id)
            time.sleep(5)

    def _process_data(self, paper_id: str, data: Dict):
        # Save node metadata
        self.papers[paper_id] = {
            "title": data.get("title"),
            "year": data.get("year"),
            "venue": data.get("venue"),
            "citationCount": data.get("citationCount")
        }
        
        # Process citations
        citations = data.get("citations", [])
        print(f"  Processing {paper_id}: {len(citations)} citations found.")
        
        valid_cites = []
        for cite in citations:
            cite_id = cite.get("paperId")
            cite_venue = cite.get("venue")
            cite_year = cite.get("year")
            
            if not cite_id: continue
            
            # Filter
            if self.is_target_journal(cite_venue) and (cite_year is None or cite_year >= 1944):
                valid_cites.append(cite_id)
                
                # Add to papers DB if new (metadata expansion)
                if cite_id not in self.papers:
                    self.papers[cite_id] = {
                        "title": cite.get("title"),
                        "year": cite_year,
                        "venue": cite_venue
                    }
                    # Add to queue for future expansion
                    if cite_id not in self.processed and cite_id not in self.queue:
                        self.queue.append(cite_id)
        
        self.edges[paper_id] = valid_cites
        print(f"    -> {len(valid_cites)} valid descendants added.")

if __name__ == "__main__":
    builder = S2GraphBuilder()
    builder.run()
