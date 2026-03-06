import requests
import json

TARGET_JOURNALS = [
    "American Economic Review",
    "Econometrica",
    "Journal of Political Economy",
    "Quarterly Journal of Economics",
    "Review of Economic Studies",
    "Journal of Economic Theory",
    "Games and Economic Behavior",
    "Theoretical Economics",
    "International Journal of Game Theory",
    "Journal of Mathematical Economics"
]

def find_journals():
    url = "https://api.openalex.org/sources"
    journal_map = {}
    
    print("Searching for Journal IDs...")
    for name in TARGET_JOURNALS:
        params = {"search": name}
        try:
            resp = requests.get(url, params=params)
            if resp.status_code == 200:
                results = resp.json().get("results", [])
                if results:
                    # Pick the best match (usually the first one with high works_count)
                    top_match = results[0]
                    journal_map[name] = {
                        "id": top_match["id"],
                        "display_name": top_match["display_name"],
                        "works_count": top_match["works_count"]
                    }
                    print(f"  Found: {name} -> {top_match['display_name']} ({top_match['id']})")
                else:
                    print(f"  Warning: No match for {name}")
            else:
                print(f"  Error searching {name}: {resp.status_code}")
        except Exception as e:
            print(f"  Exception searching {name}: {e}")
            
    print("\nJournal Mapping:")
    print(json.dumps(journal_map, indent=2))
    
    # Save to file for the builder to use
    with open("citation_graph/journal_map.json", "w") as f:
        json.dump(journal_map, f, indent=2)

if __name__ == "__main__":
    find_journals()
