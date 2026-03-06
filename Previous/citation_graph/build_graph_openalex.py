"""
OpenAlex Citation Graph Builder.

A high-performance crawler that builds a citation network starting from a seed paper (Eve),
strictly filtered by a whitelist of Journal IDs.
"""

import time
import requests
import json
from pathlib import Path
from typing import List, Dict, Set

# Configuration
EVE_ID = "W2144846366"  # Theory of Games
DATA_DIR = Path("citation_graph/data")
JOURNAL_MAP_FILE = Path("citation_graph/journal_map.json")

class OpenAlexGraphBuilder:
    API_URL = "https://api.openalex.org/works"
    
    def __init__(self):
        self.data_dir = DATA_DIR
        self.data_dir.mkdir(exist_ok=True, parents=True)
        
        self.papers_file = self.data_dir / "oa_papers.json"
        self.edges_file = self.data_dir / "oa_edges.json"
        self.queue_file = self.data_dir / "oa_queue.json"
        
        self.journal_ids = self._load_journal_ids()
        self.papers = self._load_json(self.papers_file)
        self.edges = self._load_json(self.edges_file)
        self.queue = self._load_queue()
        
        if not self.queue and EVE_ID not in self.papers:
            print(f"  [Init] Seeding queue with Eve: {EVE_ID}")
            self.queue = [EVE_ID]

    def _load_journal_ids(self) -> Set[str]:
        if not JOURNAL_MAP_FILE.exists():
            raise FileNotFoundError("Run find_journals.py first!")
        data = json.loads(JOURNAL_MAP_FILE.read_text())
        ids = {entry["id"] for entry in data.values()}
        print(f"  [Init] Loaded {len(ids)} target journal IDs.")
        return ids

    def _load_json(self, path: Path) -> Dict:
        if path.exists():
            return json.loads(path.read_text())
        return {}

    def _load_queue(self) -> List[str]:
        if self.queue_file.exists():
            return json.loads(self.queue_file.read_text())
        return []

    def save(self):
        print(f"  [Save] {len(self.papers)} papers, {sum(len(v) for v in self.edges.values())} edges, {len(self.queue)} in queue.")
        self.papers_file.write_text(json.dumps(self.papers, indent=2))
        self.edges_file.write_text(json.dumps(self.edges, indent=2))
        self.queue_file.write_text(json.dumps(self.queue, indent=2))

    def fetch_work(self, work_id: str) -> Dict | None:
        """Fetch a single work's metadata."""
        try:
            # work_id might be a full URL from a previous run or just the ID
            clean_id = work_id.split("/")[-1]
            resp = requests.get(f"{self.API_URL}/{clean_id}")
            if resp.status_code == 200:
                return resp.json()
            elif resp.status_code == 429:
                print("  [API] Rate limit on single fetch. Sleeping 2s...")
                time.sleep(2)
                return self.fetch_work(work_id)
        except Exception as e:
            print(f"  [API] Error fetching {work_id}: {e}")
        return None

    def fetch_incoming_citations(self, work_id: str) -> List[Dict]:
        """Fetch all works that cite work_id, filtered by our journal list."""
        citations = []
        cursor = "*"
        # Filter: Cites our work AND is in one of our target journals
        # We can't filter by a list of 10 sources in one API call easily (url length limits),
        # so we filter client-side or assume we fetch broad and filter locally.
        # A better approach for the API: filter by `cites:work_id`.
        
        while cursor:
            params = {
                "filter": f"cites:{work_id}",
                "per-page": 200,
                "cursor": cursor,
                "select": "id,title,publication_year,primary_location,cited_by_count"
            }
            try:
                resp = requests.get(self.API_URL, params=params)
                if resp.status_code == 200:
                    data = resp.json()
                    results = data.get("results", [])
                    
                    for work in results:
                        source = work.get("primary_location", {}).get("source", {})
                        if source and source.get("id") in self.journal_ids:
                            citations.append(work)
                            
                    cursor = data.get("meta", {}).get("next_cursor")
                    # Polite delay for pagination
                    time.sleep(0.2) 
                else:
                    print(f"  [API] Error {resp.status_code} fetching citations.")
                    break
            except Exception as e:
                print(f"  [API] Exception in citation loop: {e}")
                break
                
        return citations

    def run(self, max_steps=1000):
        print(f"=== Starting OpenAlex Graph Builder (Queue: {len(self.queue)}) ===")
        
        steps = 0
        while self.queue and steps < max_steps:
            current_id = self.queue.pop(0)
            
            # If we haven't processed this node's metadata yet, do it now
            if current_id not in self.papers:
                work_data = self.fetch_work(current_id)
                if work_data:
                    self.papers[current_id] = {
                        "title": work_data.get("title"),
                        "year": work_data.get("publication_year"),
                        "journal": work_data.get("primary_location", {}).get("source", {}).get("display_name"),
                        "citations": work_data.get("cited_by_count")
                    }
                else:
                    continue # Skip if we can't resolve the node itself

            # Sanitize title for printing to avoid encoding errors
            safe_title = self.papers[current_id]['title'] or "Unknown"
            safe_title = safe_title.encode('ascii', 'replace').decode('ascii')
            print(f"[{steps+1}/{max_steps}] Expanding: {safe_title[:50]}...")
            
            # Get Forward Citations (Who cites this?)
            citations = self.fetch_incoming_citations(current_id)
            print(f"  -> Found {len(citations)} valid citations in target journals.")
            
            new_nodes = 0
            for cite in citations:
                cite_id = cite["id"]
                
                # Add edge: Citer -> Current
                if cite_id not in self.edges:
                    self.edges[cite_id] = []
                if current_id not in self.edges[cite_id]:
                    self.edges[cite_id].append(current_id)
                
                # Store minimal metadata for citer immediately
                if cite_id not in self.papers:
                    self.papers[cite_id] = {
                        "title": cite["title"],
                        "year": cite["publication_year"],
                        "journal": cite.get("primary_location", {}).get("source", {}).get("display_name"),
                        "citations": cite["cited_by_count"]
                    }
                    # Add to queue to expand ITS citations later
                    self.queue.append(cite_id)
                    new_nodes += 1
            
            if new_nodes > 0:
                print(f"  -> Added {new_nodes} new nodes to queue.")

            steps += 1
            if steps % 50 == 0:
                self.save()
        
        self.save()
        print("=== Run Complete ===")

if __name__ == "__main__":
    builder = OpenAlexGraphBuilder()
    builder.run(max_steps=50000)
