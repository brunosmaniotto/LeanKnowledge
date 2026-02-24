import requests
import json

API_KEY = "MrFq2T4RvDaFibagnzP0V2YrcSh7V3P38HBZGXnv"
URL = "https://api.semanticscholar.org/graph/v1/paper/batch"

def test_key():
    headers = {"x-api-key": API_KEY}
    payload = {"ids": ["649def34f8be52c8b66281af98ae884c09aef38b"]} # Graph Attention Networks
    
    print("Testing S2 API Key...")
    try:
        resp = requests.post(URL, headers=headers, json=payload, params={"fields": "title,year"})
        print(f"Status: {resp.status_code}")
        print("Headers:")
        for k, v in resp.headers.items():
            if "limit" in k.lower() or "remaining" in k.lower():
                print(f"  {k}: {v}")
        
        if resp.status_code == 200:
            print("\nResponse:")
            print(json.dumps(resp.json(), indent=2))
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    test_key()
