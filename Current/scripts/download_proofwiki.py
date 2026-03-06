"""Download the NaturalProofs ProofWiki dataset.

Source: https://github.com/wellecks/naturalproofs (NeurIPS 2021)
Contains 19,734 theorems with 19,956 proofs from ProofWiki.

Usage:
    python scripts/download_proofwiki.py [--output data/proofwiki.json]
"""

import argparse
import json
import urllib.request
import sys
from pathlib import Path

# The NaturalProofs dataset is hosted on Zenodo
# Direct download URL for the ProofWiki JSON
ZENODO_URL = "https://zenodo.org/records/4902289/files/naturalproofs_proofwiki.json"


def download(url: str, output: Path) -> None:
    output.parent.mkdir(parents=True, exist_ok=True)

    if output.exists():
        size_mb = output.stat().st_size / 1024 / 1024
        print(f"Already exists: {output} ({size_mb:.1f} MB)")
        return

    print(f"Downloading from {url}...")
    print(f"  → {output}")

    def progress(block_num, block_size, total_size):
        downloaded = block_num * block_size
        if total_size > 0:
            pct = min(100, downloaded * 100 / total_size)
            mb = downloaded / 1024 / 1024
            print(f"\r  {pct:.0f}% ({mb:.1f} MB)", end="", flush=True)

    urllib.request.urlretrieve(url, str(output), reporthook=progress)
    print()

    size_mb = output.stat().st_size / 1024 / 1024
    print(f"  Done: {size_mb:.1f} MB")


def summarize(path: Path) -> None:
    """Print a quick summary of the dataset."""
    data = json.loads(path.read_text(encoding="utf-8"))
    ds = data["dataset"]

    n_theorems = len(ds["theorems"])
    n_definitions = len(ds["definitions"])
    n_others = len(ds.get("others", []))
    n_with_proof = sum(1 for t in ds["theorems"] if t.get("proofs"))
    n_proofs = sum(len(t.get("proofs", [])) for t in ds["theorems"])

    # Category distribution (top 20)
    from collections import Counter
    cats = Counter()
    for t in ds["theorems"]:
        for c in t.get("toplevel_categories", []):
            cats[c] += 1

    print(f"\n=== NaturalProofs ProofWiki Dataset ===")
    print(f"  Theorems:     {n_theorems:,}")
    print(f"  With proof:   {n_with_proof:,} ({n_with_proof/n_theorems:.0%})")
    print(f"  Total proofs: {n_proofs:,}")
    print(f"  Definitions:  {n_definitions:,}")
    print(f"  Others:       {n_others:,}")
    print(f"\n  Top categories:")
    for cat, count in cats.most_common(20):
        print(f"    {cat}: {count}")


def main():
    parser = argparse.ArgumentParser(description="Download NaturalProofs ProofWiki dataset")
    parser.add_argument("--output", default="data/proofwiki.json",
                        help="Output path (default: data/proofwiki.json)")
    parser.add_argument("--summary", action="store_true",
                        help="Print dataset summary after download")
    args = parser.parse_args()

    output = Path(args.output)
    download(ZENODO_URL, output)

    if args.summary:
        summarize(output)


if __name__ == "__main__":
    main()
