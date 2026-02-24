import requests
import json
import time

def search_eve():
    url = "https://api.semanticscholar.org/graph/v1/paper/search"
    params = {
        "query": "Theory of Games and Economic Behavior Von Neumann Morgenstern",
        "limit": 5,
        "fields": "paperId,title,year,citationCount,venue"
    }
    
    wait = 5
    for attempt in range(3):
        try:
            print(f"Searching for Eve (Attempt {attempt+1})...")
            response = requests.get(url, params=params)
            
            if response.status_code == 200:
                data = response.json()
                print(json.dumps(data, indent=2))
                return
            elif response.status_code == 429:
                print(f"429 Hit. Waiting {wait} seconds...")
                time.sleep(wait)
                wait *= 2
            else:
                print(f"Error: {response.status_code} - {response.text}")
                return
                
        except Exception as e:
            print(f"Exception: {e}")
            return

if __name__ == "__main__":
    search_eve()
