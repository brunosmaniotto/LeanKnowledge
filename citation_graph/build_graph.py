"""
Microeconomic Theory Citation Graph Builder.

Goal: Build a directed graph of papers starting from 'Theory of Games and Economic Behavior' (1944),
restricted to top general and theory journals.
"""

import time
import requests
import json
from pathlib import Path
from typing import List, Set, Dict, Optional

# Top 10 Journals (approximate string matching needed for API)
TARGET_JOURNALS = {
    "American Economic Review",
    "The American Economic Review",
    "Econometrica",
    "Journal of Political Economy",
    "The Journal of Political Economy",
    "Quarterly Journal of Economics",
    "The Quarterly Journal of Economics",
    "Review of Economic Studies",
    "The Review of Economic Studies",
    "Journal of Economic Theory",
    "Games and Economic Behavior",
    "Theoretical Economics",
    "International Journal of Game Theory",
    "Journal of Mathematical Economics"
}

# "Eve": Theory of Games and Economic Behavior
EVE_ID = "5d9dd70be51c2bb12a1e9a6addd0af5dd42aed13" 

class EconGraphBuilder:
    API_URL = "https://api.semanticscholar.org/graph/v1/paper"
    
    def __init__(self, data_dir: Path):
        self.data_dir = data_dir
        self.data_dir.mkdir(exist_ok=True)
        self.papers_file = self.data_dir / "papers.json"
        self.edges_file = self.data_dir / "citations.json"
        self.queue_file = self.data_dir / "queue.json"
        
        # Load state
        self.papers = self._load_json(self.papers_file)
        self.edges = self._load_json(self.edges_file)  # Adjacency list: citer -> [cited]
        self.queue = self._load_queue()
        
        if not self.queue and EVE_ID not in self.papers:
            self.queue = [EVE_ID]

        self.last_request_time = 0.0

    def _load_json(self, path: Path) -> Dict:
        if path.exists():
            return json.loads(path.read_text())
        return {}

    def _load_queue(self) -> List[str]:
        if self.queue_file.exists():
            return json.loads(self.queue_file.read_text())
        return []

    def save(self):
        print("  [Graph] Saving state...")
        self.papers_file.write_text(json.dumps(self.papers, indent=2))
        self.edges_file.write_text(json.dumps(self.edges, indent=2))
        self.queue_file.write_text(json.dumps(self.queue, indent=2))

    def is_target_journal(self, venue: str) -> bool:
        """Check if the venue matches our Top 10 list."""
        if not venue:
            return False
        return venue in TARGET_JOURNALS

    def _wait_for_rate_limit(self):
        """Enforce 1s delay between requests."""
        now = time.time()
        elapsed = now - self.last_request_time
        if elapsed < 1.0:
            time.sleep(1.0 - elapsed)
        self.last_request_time = time.time()

    def fetch_paper_details(self, paper_id: str) -> Optional[Dict]:
        """Fetch details including citations (forward) and references (backward)."""
        # We need 'citations' to find WHO cites this paper (Forward traversal)
        fields = "paperId,title,year,venue,citationCount,citations.paperId,citations.title,citations.year,citations.venue"
        
        backoff = 5
        max_retries = 5
        
        for attempt in range(max_retries):
            self._wait_for_rate_limit()
            try:
                response = requests.get(
                    f"{self.API_URL}/{paper_id}",
                    params={"fields": fields},
                    timeout=10
                )
                
                if response.status_code == 200:
                    return response.json()
                elif response.status_code == 429:
                    print(f"  [API] 429 Hit. Backoff {backoff}s...")
                    time.sleep(backoff)
                    backoff *= 2
                elif response.status_code == 404:
                    print(f"  [API] 404 Paper not found: {paper_id}")
                    return None
                else:
                    print(f"  [API] Error {response.status_code}: {response.text}")
                    return None
            except Exception as e:
                print(f"  [API] Exception: {e}")
                time.sleep(backoff)
                backoff *= 2
        return None

    def run(self, max_steps=50):
        print(f"=== Starting Graph Builder (Queue: {len(self.queue)}) ===")
        
        steps = 0
        while self.queue and steps < max_steps:
            current_id = self.queue.pop(0)
            
            # Skip if already processed fully
            if current_id in self.papers and self.papers[current_id].get("processed"):
                continue
                
            print(f"[{steps+1}/{max_steps}] Processing: {current_id}")
            data = self.fetch_paper_details(current_id)
            
            if not data:
                continue
                
            # Store the current paper node
            self.papers[current_id] = {
                "title": data.get("title"),
                "year": data.get("year"),
                "venue": data.get("venue"),
                "citationCount": data.get("citationCount"),
                "processed": True
            }
            
            # Process FORWARD citations (papers that cite THIS paper)
            # This grows the graph forward in time
            citations = data.get("citations", [])
            print(f"  -> Found {len(citations)} citations.")
            
            added_count = 0
            for cite in citations:
                cite_id = cite.get("paperId")
                cite_venue = cite.get("venue")
                cite_year = cite.get("year")
                
                if not cite_id: continue
                
                # FILTER: Only add to queue/graph if it matches our constraints
                is_target = self.is_target_journal(cite_venue)
                is_modern = (cite_year is not None) and (cite_year >= 1944)
                
                if is_target and is_modern:
                    # Add edge: Citer -> Current (Citer cites Current)
                    if cite_id not in self.edges:
                        self.edges[cite_id] = []
                    if current_id not in self.edges[cite_id]:
                        self.edges[cite_id].append(current_id)
                    
                    # Add Citer to queue if not seen
                    if cite_id not in self.papers and cite_id not in self.queue:
                        self.queue.append(cite_id)
                        added_count += 1
            
            print(f"  -> Added {added_count} valid descendants to queue.")
            
            steps += 1
            if steps % 5 == 0:
                self.save()
        
        self.save()
        print("=== Run Complete ===")

if __name__ == "__main__":
    builder = EconGraphBuilder(Path("citation_graph/data"))
    builder.run()
