import requests
import json
import time
from pathlib import Path

API_KEY = "MrFq2T4RvDaFibagnzP0V2YrcSh7V3P38HBZGXnv"
OA_QUEUE_FILE = Path("citation_graph/data/oa_queue.json")
OA_PAPERS_FILE = Path("citation_graph/data/oa_papers.json")
S2_QUEUE_FILE = Path("citation_graph/data/s2_queue.json")

def map_ids():
    if not OA_QUEUE_FILE.exists():
        print("No OA queue found.")
        return

    oa_ids = json.loads(OA_QUEUE_FILE.read_text())
    oa_papers = json.loads(OA_PAPERS_FILE.read_text())
    
    print(f"Mapping {len(oa_ids)} OpenAlex IDs to S2...")
    
    s2_ids = []
    
    headers = {"x-api-key": API_KEY}
    url = "https://api.semanticscholar.org/graph/v1/paper/batch"
    
    # S2 Batch supports up to 500 IDs, but we can't pass OA IDs directly to batch
    # We have to search by title for each one.
    
    search_url = "https://api.semanticscholar.org/graph/v1/paper/search"
    
    for i, oaid in enumerate(oa_ids):
        paper = oa_papers.get(oaid)
        if not paper:
            print(f"  Skipping {oaid} (no metadata)")
            continue
            
        title = paper.get("title")
        if not title:
            continue
            
        print(f"  [{i+1}/{len(oa_ids)}] Searching: {title[:50]}...")
        
        try:
            params = {"query": title, "limit": 1, "fields": "paperId,title,year"}
            resp = requests.get(search_url, headers=headers, params=params)
            
            if resp.status_code == 200:
                data = resp.json()
                if data.get("data"):
                    s2_id = data["data"][0]["paperId"]
                    s2_ids.append(s2_id)
                    print(f"    -> Found: {s2_id}")
                else:
                    print("    -> Not found.")
            else:
                print(f"    -> Error {resp.status_code}")
                
            time.sleep(1.1) # 1 RPS limit
            
        except Exception as e:
            print(f"    -> Exception: {e}")
            
    print(f"Mapped {len(s2_ids)} IDs.")
    S2_QUEUE_FILE.write_text(json.dumps(s2_ids, indent=2))

if __name__ == "__main__":
    map_ids()
