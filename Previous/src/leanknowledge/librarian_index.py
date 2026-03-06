"""Unified search index for the Librarian agent.

Combines Rosetta Stone pairs (Mathlib NL-Lean data) and pipeline training data
into a single BM25-searchable index with name-based lookup.
"""

import json
import math
import re
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path
from typing import Literal

from pydantic import BaseModel, Field

PROJECT_ROOT = Path(__file__).resolve().parents[2]
INDEX_PATH = PROJECT_ROOT / "librarian_index.json"
PAIRS_DIR = PROJECT_ROOT / "rosetta_stone" / "pairs"
TRAINING_DIR = PROJECT_ROOT / "training_data"

# BM25 parameters
K1 = 1.5
B = 0.75

STOPWORDS = frozenset(
    "a an the is are was were be been being have has had do does did "
    "will would shall should may might can could of in to for on with "
    "at by from as into through during before after above below between "
    "and or not no nor but if then else when where how what which who "
    "whom this that these those it its all each every both few more most "
    "other some such than too very just also".split()
)


class IndexEntry(BaseModel):
    id: str  # "rosetta:Mathlib.Order.Defs.le_refl" or "pipeline:budget_bound"
    lean_name: str  # "le_refl", "budget_bound"
    module: str  # "Mathlib.Order.Defs.PartialOrder" or "microeconomics"
    import_path: str  # Same as module for Mathlib; empty for pipeline
    nl_statement: str  # Plain English description
    lean_snippet: str  # First 300 chars of Lean code
    source: Literal["rosetta", "pipeline"]
    tags: list[str] = Field(default_factory=list)


# ---------------------------------------------------------------------------
# Tokenization
# ---------------------------------------------------------------------------

def _tokenize(text: str) -> list[str]:
    """Lowercase, split on non-alphanumeric, remove stopwords."""
    tokens = re.findall(r"[a-z0-9]+", text.lower())
    return [t for t in tokens if t not in STOPWORDS and len(t) > 1]


# ---------------------------------------------------------------------------
# Data loading
# ---------------------------------------------------------------------------

def _module_from_filename(fpath: Path) -> str:
    """Infer Mathlib module name from a pair file's filename."""
    stem = fpath.stem
    # Newer files: "AlgebraicGeometry_ValuativeCriterion" or "Mathlib.Foo.Bar"
    # Older files: "mathlib_algebra_addconstmap_basic"
    if "." in stem:
        return stem  # Already dotted module path
    # Convert underscore-separated to dotted, capitalizing each segment
    # "mathlib_algebra_addconstmap_basic" → use as-is since we can't reliably reconstruct casing
    return stem.replace("_", ".")


def _load_rosetta_entries(pairs_dir: Path) -> list[IndexEntry]:
    """Load entries from Rosetta Stone pair files.

    Handles two formats:
    - Old: {"module": "...", "pairs": [{"id", "mathlib_name", "lean_code", "nl_proof", "metadata"}]}
    - New: [{"name", "nl_statement", "nl_strategy", "complexity", ...}]
    """
    entries = []
    if not pairs_dir.exists():
        return entries

    for fpath in sorted(pairs_dir.glob("*.json")):
        if fpath.name == "index.json":
            continue
        try:
            data = json.loads(fpath.read_text(encoding="utf-8"))
        except (json.JSONDecodeError, OSError):
            continue

        if isinstance(data, dict):
            # Old format: {module, pairs: [...]}
            module_name = data.get("module", "")
            for pair in data.get("pairs", []):
                entry = _parse_old_format_pair(pair, module_name)
                if entry:
                    entries.append(entry)
        elif isinstance(data, list):
            # New format: flat list of entries
            module_name = _module_from_filename(fpath)
            for pair in data:
                entry = _parse_new_format_pair(pair, module_name)
                if entry:
                    entries.append(entry)

    return entries


def _parse_old_format_pair(pair: dict, module_name: str) -> IndexEntry | None:
    """Parse a pair from the old {id, mathlib_name, lean_code, nl_proof, metadata} format."""
    pair_id = pair.get("id", "")
    mathlib_name = pair.get("mathlib_name", "")
    mathlib_module = pair.get("mathlib_module", module_name)

    nl_proof = pair.get("nl_proof", {})
    statement = nl_proof.get("statement", "") if isinstance(nl_proof, dict) else ""

    lean_code = pair.get("lean_code", "")
    metadata = pair.get("metadata", {})
    tags = metadata.get("tags", []) if isinstance(metadata, dict) else []

    if not statement and not mathlib_name:
        return None

    return IndexEntry(
        id=f"rosetta:{pair_id}" if pair_id else f"rosetta:{mathlib_module}.{mathlib_name}",
        lean_name=mathlib_name,
        module=mathlib_module,
        import_path=mathlib_module,
        nl_statement=statement,
        lean_snippet=lean_code[:300],
        source="rosetta",
        tags=tags,
    )


def _parse_new_format_pair(pair: dict, module_name: str) -> IndexEntry | None:
    """Parse a pair from the new {name, nl_statement, nl_strategy, ...} format."""
    name = pair.get("name", "")
    statement = pair.get("nl_statement", "")

    if not statement and not name:
        return None

    tags = []
    complexity = pair.get("complexity", "")
    if complexity:
        tags.append(complexity)
    tactics = pair.get("lean_tactics_used", [])
    if isinstance(tactics, list):
        tags.extend(tactics[:3])

    return IndexEntry(
        id=f"rosetta:{module_name}.{name}" if name else f"rosetta:{module_name}",
        lean_name=name,
        module=module_name,
        import_path=module_name,
        nl_statement=statement,
        lean_snippet="",  # New format doesn't include lean_code
        source="rosetta",
        tags=tags,
    )


def _load_pipeline_entries(training_dir: Path) -> list[IndexEntry]:
    """Load entries from pipeline training data files."""
    entries = []
    if not training_dir.exists():
        return entries

    for fpath in sorted(training_dir.glob("*.json")):
        try:
            data = json.loads(fpath.read_text(encoding="utf-8"))
        except (json.JSONDecodeError, OSError):
            continue

        theorem = data.get("theorem", {})
        name = theorem.get("name", "")
        statement = theorem.get("statement", "")
        domain = theorem.get("domain", "")
        lean_code = data.get("lean_code", "")

        if not statement and not name:
            continue

        entries.append(IndexEntry(
            id=f"pipeline:{name}",
            lean_name=name,
            module=domain,
            import_path="",
            nl_statement=statement,
            lean_snippet=lean_code[:300] if lean_code else "",
            source="pipeline",
            tags=[domain] if domain else [],
        ))
    return entries


# ---------------------------------------------------------------------------
# BM25 engine
# ---------------------------------------------------------------------------

class _BM25:
    """Minimal BM25 implementation using only stdlib."""

    def __init__(self, documents: list[list[str]]):
        self.n_docs = len(documents)
        self.avg_dl = sum(len(d) for d in documents) / max(self.n_docs, 1)
        self.doc_lens = [len(d) for d in documents]
        self.doc_freqs: list[Counter] = [Counter(d) for d in documents]

        # IDF: log((N - df + 0.5) / (df + 0.5) + 1)
        df: Counter = Counter()
        for d in documents:
            df.update(set(d))
        self.idf: dict[str, float] = {}
        for term, freq in df.items():
            self.idf[term] = math.log((self.n_docs - freq + 0.5) / (freq + 0.5) + 1.0)

    def score(self, query_tokens: list[str], top_k: int = 20) -> list[tuple[int, float]]:
        """Return (doc_index, score) pairs sorted descending by score."""
        scores: list[float] = [0.0] * self.n_docs
        for term in query_tokens:
            idf_val = self.idf.get(term, 0.0)
            if idf_val <= 0:
                continue
            for i in range(self.n_docs):
                tf = self.doc_freqs[i].get(term, 0)
                if tf == 0:
                    continue
                dl = self.doc_lens[i]
                numerator = tf * (K1 + 1)
                denominator = tf + K1 * (1 - B + B * dl / self.avg_dl)
                scores[i] += idf_val * numerator / denominator

        # Get top-k by partial sort
        if self.n_docs <= top_k:
            ranked = [(i, scores[i]) for i in range(self.n_docs) if scores[i] > 0]
        else:
            # Use a simple approach: collect all nonzero, sort, slice
            ranked = [(i, scores[i]) for i in range(self.n_docs) if scores[i] > 0]
        ranked.sort(key=lambda x: x[1], reverse=True)
        return ranked[:top_k]


# ---------------------------------------------------------------------------
# LibrarianIndex
# ---------------------------------------------------------------------------

class LibrarianIndex:
    """Unified search index combining Rosetta Stone and pipeline data."""

    def __init__(self, index_path: Path | None = None):
        self.index_path = index_path or INDEX_PATH
        self.entries: list[IndexEntry] = []
        self._bm25: _BM25 | None = None
        self._name_map: dict[str, list[int]] = {}  # normalized name -> entry indices
        self._loaded = False

    def load(self) -> bool:
        """Load index from disk. Returns True if successful."""
        if not self.index_path.exists():
            return False
        try:
            data = json.loads(self.index_path.read_text(encoding="utf-8"))
            self.entries = [IndexEntry.model_validate(e) for e in data["entries"]]
            self._build_search_structures()
            self._loaded = True
            return True
        except Exception as e:
            print(f"  [librarian-index] Failed to load index: {e}")
            return False

    def build(
        self,
        pairs_dir: Path | None = None,
        training_dir: Path | None = None,
    ) -> int:
        """Build index from source data. Returns entry count."""
        pairs_dir = pairs_dir or PAIRS_DIR
        training_dir = training_dir or TRAINING_DIR

        print(f"  [librarian-index] Loading Rosetta Stone pairs from {pairs_dir}...")
        rosetta = _load_rosetta_entries(pairs_dir)
        print(f"  [librarian-index]   {len(rosetta)} entries from Rosetta Stone")

        print(f"  [librarian-index] Loading pipeline training data from {training_dir}...")
        pipeline = _load_pipeline_entries(training_dir)
        print(f"  [librarian-index]   {len(pipeline)} entries from pipeline")

        self.entries = rosetta + pipeline
        self._build_search_structures()
        self._loaded = True

        print(f"  [librarian-index] Total: {len(self.entries)} entries indexed")
        return len(self.entries)

    def save(self):
        """Persist index to disk."""
        data = {
            "version": 1,
            "built_at": datetime.now(timezone.utc).isoformat(),
            "entry_count": len(self.entries),
            "entries": [e.model_dump() for e in self.entries],
        }
        self.index_path.write_text(json.dumps(data, separators=(",", ":")), encoding="utf-8")
        size_mb = self.index_path.stat().st_size / (1024 * 1024)
        print(f"  [librarian-index] Saved {len(self.entries)} entries ({size_mb:.1f} MB)")

    def _build_search_structures(self):
        """Build BM25 index and name lookup map from entries."""
        # Build document corpus for BM25 (NL statement + tags + lean name)
        documents = []
        for entry in self.entries:
            tokens = _tokenize(entry.nl_statement)
            tokens.extend(_tokenize(entry.lean_name.replace("_", " ").replace(".", " ")))
            tokens.extend(_tokenize(" ".join(entry.tags)))
            documents.append(tokens)
        self._bm25 = _BM25(documents)

        # Build name lookup map
        self._name_map = {}
        for i, entry in enumerate(self.entries):
            # Index by full lean_name and by last component
            for name_variant in _name_variants(entry.lean_name):
                self._name_map.setdefault(name_variant, []).append(i)

    def _ensure_loaded(self):
        """Lazy-load index if not already loaded."""
        if not self._loaded:
            if not self.load():
                print("  [librarian-index] No index found. Run: python -m leanknowledge.librarian_index --build")

    # --- Public search API ---

    def lookup(self, query: str, limit: int = 20) -> list[IndexEntry]:
        """Combined search: name-based first, then BM25 keyword search."""
        self._ensure_loaded()
        if not self.entries:
            return []

        results: list[IndexEntry] = []
        seen: set[int] = set()

        # 1. Name-based search
        for idx in self._name_search(query):
            if idx not in seen and len(results) < limit:
                seen.add(idx)
                results.append(self.entries[idx])

        # 2. BM25 keyword search for remaining slots
        if len(results) < limit and self._bm25:
            tokens = _tokenize(query)
            if tokens:
                for idx, _score in self._bm25.score(tokens, top_k=limit * 2):
                    if idx not in seen and len(results) < limit:
                        seen.add(idx)
                        results.append(self.entries[idx])

        return results

    def name_lookup(self, name: str, limit: int = 10) -> list[IndexEntry]:
        """Search by Lean name only."""
        self._ensure_loaded()
        if not self.entries:
            return []

        indices = self._name_search(name)
        return [self.entries[i] for i in indices[:limit]]

    def _name_search(self, query: str) -> list[int]:
        """Return entry indices matching by name. Exact first, then substring.

        Only triggers substring matching for short, name-like queries (≤5 words)
        to avoid false positives from NL sentences containing common Lean name substrings.
        """
        normalized = query.lower().strip().replace(" ", "_")

        # Exact match
        if normalized in self._name_map:
            return self._name_map[normalized]

        # Only do substring matching for short, name-like queries
        # Long NL sentences would produce too many false substring matches
        word_count = len(query.strip().split())
        if word_count > 5:
            return []

        # Substring match (for queries like "IsCompact" matching "IsCompact.exists_isMaxOn")
        matches = []
        for key, indices in self._name_map.items():
            if normalized in key or key in normalized:
                matches.extend(indices)

        # Deduplicate preserving order
        seen: set[int] = set()
        deduped = []
        for idx in matches:
            if idx not in seen:
                seen.add(idx)
                deduped.append(idx)
        return deduped

    def stats(self) -> dict:
        """Return index statistics."""
        self._ensure_loaded()
        rosetta_count = sum(1 for e in self.entries if e.source == "rosetta")
        pipeline_count = sum(1 for e in self.entries if e.source == "pipeline")
        modules = set(e.module for e in self.entries if e.source == "rosetta")
        return {
            "total_entries": len(self.entries),
            "rosetta_entries": rosetta_count,
            "pipeline_entries": pipeline_count,
            "unique_modules": len(modules),
            "index_file": str(self.index_path),
            "index_exists": self.index_path.exists(),
        }


def _name_variants(lean_name: str) -> list[str]:
    """Generate normalized name variants for indexing."""
    if not lean_name:
        return []
    lower = lean_name.lower()
    variants = [lower]
    # Last component after final dot
    if "." in lower:
        variants.append(lower.rsplit(".", 1)[1])
    # Underscore-separated parts joined
    variants.append(lower.replace(".", "_"))
    return variants


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="Build and query the Librarian search index"
    )
    parser.add_argument("--build", action="store_true", help="Build index from source data")
    parser.add_argument("--stats", action="store_true", help="Show index statistics")
    parser.add_argument("--query", type=str, help="Test BM25 keyword search")
    parser.add_argument("--name", type=str, help="Test name-based lookup")
    parser.add_argument("--pairs-dir", type=str, default=None, help="Rosetta Stone pairs directory")
    parser.add_argument("--training-dir", type=str, default=None, help="Pipeline training data directory")
    parser.add_argument("--limit", type=int, default=10, help="Max results to show")
    args = parser.parse_args()

    idx = LibrarianIndex()

    if args.build:
        pairs_dir = Path(args.pairs_dir) if args.pairs_dir else None
        training_dir = Path(args.training_dir) if args.training_dir else None
        count = idx.build(pairs_dir=pairs_dir, training_dir=training_dir)
        idx.save()
        print(f"\nIndex built: {count} entries")

    elif args.stats:
        s = idx.stats()
        print(f"Index: {s['index_file']}")
        print(f"  Exists: {s['index_exists']}")
        print(f"  Total entries: {s['total_entries']}")
        print(f"  Rosetta Stone: {s['rosetta_entries']}")
        print(f"  Pipeline: {s['pipeline_entries']}")
        print(f"  Unique modules: {s['unique_modules']}")

    elif args.query:
        results = idx.lookup(args.query, limit=args.limit)
        print(f"Query: {args.query!r}")
        print(f"Results: {len(results)}\n")
        for i, entry in enumerate(results, 1):
            print(f"  {i}. [{entry.source}] {entry.lean_name}")
            print(f"     Module: {entry.module}")
            print(f"     NL: {entry.nl_statement[:120]}")
            if entry.tags:
                print(f"     Tags: {', '.join(entry.tags[:5])}")
            print()

    elif args.name:
        results = idx.name_lookup(args.name, limit=args.limit)
        print(f"Name: {args.name!r}")
        print(f"Results: {len(results)}\n")
        for i, entry in enumerate(results, 1):
            print(f"  {i}. [{entry.source}] {entry.lean_name}")
            print(f"     Module: {entry.module}")
            print(f"     NL: {entry.nl_statement[:120]}")
            print()

    else:
        parser.print_help()


if __name__ == "__main__":
    main()
