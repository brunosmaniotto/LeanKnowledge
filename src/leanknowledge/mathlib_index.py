"""Mathlib Declaration Index — retrieval-augmented generation for Lean 4 translation.

The #1 failure mode in the pipeline is hallucinated Mathlib identifiers (54% of
errors). This module retrieves real Mathlib lemma names and signatures so the
translator prompt can reference actual declarations.

Two search backends:
  1. **Embedding** (default): Uses LiteLLM's embedding API (OpenAI, etc.) for
     semantic similarity search. Configurable via LK_EMBEDDING_MODEL env var.
  2. **TF-IDF fallback**: Lightweight TF-IDF implementation (pure stdlib, no
     external deps) over declaration names and signatures. Free, fast, and
     surprisingly effective for identifier lookup since queries and targets
     share mathematical vocabulary.

The index supports two data sources:
  - Mathlib declarations (name, type signature, docstring)
  - Rosetta Stone entries (from rosetta_stone.jsonl — growing corpus of
    verified NL→Lean translations)

Usage:
    index = MathlibIndex()
    index.build_from_declarations([
        {"name": "Nat.add_comm", "signature": "∀ (n m : ℕ), n + m = m + n",
         "docstring": "Addition is commutative on natural numbers."},
    ])
    results = index.search("commutativity of addition", top_k=5)
"""

import json
import math
import os
import re
from collections import Counter
from dataclasses import dataclass, field
from pathlib import Path

# Embedding model — configurable, defaults to OpenAI's small model
EMBEDDING_MODEL = os.environ.get("LK_EMBEDDING_MODEL", "text-embedding-3-small")


# ---------------------------------------------------------------------------
# Data types
# ---------------------------------------------------------------------------

@dataclass
class SearchResult:
    """A single search result from the Mathlib index."""
    name: str
    signature: str
    docstring: str
    score: float
    source: str  # "mathlib" or "rosetta"


@dataclass
class Declaration:
    """A Mathlib or Rosetta Stone declaration."""
    name: str
    signature: str
    docstring: str
    source: str  # "mathlib" or "rosetta"

    def search_text(self) -> str:
        """Combined text for indexing — name + signature + docstring."""
        parts = [self.name]
        if self.signature:
            parts.append(self.signature)
        if self.docstring:
            parts.append(self.docstring)
        return " ".join(parts)


# ---------------------------------------------------------------------------
# TF-IDF backend (offline fallback)
# ---------------------------------------------------------------------------

def _tokenize(text: str) -> list[str]:
    """Simple tokenizer for mathematical text.

    Splits on whitespace, punctuation, and camelCase/dot boundaries.
    Keeps mathematical symbols as tokens.
    """
    # Split qualified names (e.g., "Nat.add_comm" → ["Nat", "add", "comm"])
    text = re.sub(r'\.', ' ', text)
    text = re.sub(r'_', ' ', text)
    # Split camelCase
    text = re.sub(r'([a-z])([A-Z])', r'\1 \2', text)
    # Split on non-alphanumeric (keep unicode math symbols)
    tokens = re.findall(r'[a-zA-Z\u0370-\u03FF\u2100-\u214F\u2200-\u22FF]+|\d+', text.lower())
    return tokens


class TfidfIndex:
    """Lightweight TF-IDF index using only stdlib + basic math.

    No scikit-learn dependency — implements TF-IDF from scratch so the
    module works in environments without optional deps.
    """

    def __init__(self):
        self._documents: list[str] = []   # raw text per document
        self._vocab: dict[str, int] = {}  # term → index
        self._idf: dict[str, float] = {}  # term → IDF weight
        self._tfidf: list[dict[str, float]] = []  # per-doc TF-IDF vectors (sparse)

    def fit(self, documents: list[str]) -> None:
        """Build the TF-IDF index from a list of documents."""
        self._documents = documents
        n = len(documents)
        if n == 0:
            return

        # Tokenize all documents
        doc_tokens = [_tokenize(doc) for doc in documents]

        # Build vocabulary and document frequencies
        df: Counter = Counter()
        vocab: set[str] = set()
        for tokens in doc_tokens:
            unique = set(tokens)
            vocab.update(unique)
            df.update(unique)

        self._vocab = {term: i for i, term in enumerate(sorted(vocab))}

        # IDF: log(N / df) with smoothing
        self._idf = {
            term: math.log((n + 1) / (count + 1)) + 1
            for term, count in df.items()
        }

        # Build sparse TF-IDF vectors for each document
        self._tfidf = []
        for tokens in doc_tokens:
            tf = Counter(tokens)
            total = len(tokens) if tokens else 1
            vec = {}
            for term, count in tf.items():
                tf_val = count / total
                idf_val = self._idf.get(term, 1.0)
                vec[term] = tf_val * idf_val
            self._tfidf.append(vec)

    def query(self, text: str, top_k: int = 10) -> list[tuple[int, float]]:
        """Search the index. Returns [(doc_index, score), ...] sorted by score."""
        if not self._tfidf:
            return []

        tokens = _tokenize(text)
        tf = Counter(tokens)
        total = len(tokens) if tokens else 1

        # Build query vector
        q_vec: dict[str, float] = {}
        for term, count in tf.items():
            tf_val = count / total
            idf_val = self._idf.get(term, 1.0)
            q_vec[term] = tf_val * idf_val

        # Cosine similarity against all documents
        q_norm = math.sqrt(sum(v * v for v in q_vec.values())) or 1.0
        scores: list[tuple[int, float]] = []

        for idx, doc_vec in enumerate(self._tfidf):
            # Dot product (sparse)
            dot = sum(q_vec.get(t, 0) * w for t, w in doc_vec.items())
            doc_norm = math.sqrt(sum(v * v for v in doc_vec.values())) or 1.0
            sim = dot / (q_norm * doc_norm)
            if sim > 0:
                scores.append((idx, sim))

        scores.sort(key=lambda x: -x[1])
        return scores[:top_k]

    def to_dict(self) -> dict:
        """Serialize for JSON persistence."""
        return {
            "documents": self._documents,
            "vocab": self._vocab,
            "idf": self._idf,
            "tfidf": [
                {term: weight for term, weight in vec.items()}
                for vec in self._tfidf
            ],
        }

    @classmethod
    def from_dict(cls, data: dict) -> "TfidfIndex":
        """Deserialize from JSON."""
        idx = cls()
        idx._documents = data["documents"]
        idx._vocab = data["vocab"]
        idx._idf = data["idf"]
        idx._tfidf = data["tfidf"]
        return idx


# ---------------------------------------------------------------------------
# Embedding backend (API-based)
# ---------------------------------------------------------------------------

def _get_embeddings(texts: list[str], model: str = EMBEDDING_MODEL) -> list[list[float]] | None:
    """Get embeddings via LiteLLM. Returns None if API is unavailable."""
    try:
        import litellm
        response = litellm.embedding(model=model, input=texts)
        return [item["embedding"] for item in response.data]
    except Exception:
        return None


def _cosine_similarity(a: list[float], b: list[float]) -> float:
    """Cosine similarity between two vectors."""
    dot = sum(x * y for x, y in zip(a, b))
    norm_a = math.sqrt(sum(x * x for x in a))
    norm_b = math.sqrt(sum(x * x for x in b))
    if norm_a == 0 or norm_b == 0:
        return 0.0
    return dot / (norm_a * norm_b)


# ---------------------------------------------------------------------------
# Main index class
# ---------------------------------------------------------------------------

class MathlibIndex:
    """Searchable index of Mathlib declarations and Rosetta Stone entries.

    Supports two backends:
      1. Embedding (semantic similarity via LiteLLM)
      2. TF-IDF (keyword matching, always available)

    The index is incremental — new entries can be added without rebuilding.
    Both backends are kept in sync.

    Args:
        declarations_path: Path to a JSON file of Mathlib declarations.
        rosetta_path: Path to rosetta_stone.jsonl (growing corpus).
        use_embeddings: Whether to attempt embedding-based search.
            Falls back to TF-IDF if the API is unavailable.
    """

    def __init__(
        self,
        declarations_path: Path | None = None,
        rosetta_path: Path | None = None,
        use_embeddings: bool = True,
    ):
        self._declarations: list[Declaration] = []
        self._name_set: set[str] = set()
        self._name_map: dict[str, Declaration] = {}
        self._rosetta_lean: dict[str, str] = {}  # item_id → full lean code
        self._tfidf = TfidfIndex()
        self._embeddings: list[list[float]] | None = None
        self._use_embeddings = use_embeddings

        if declarations_path and declarations_path.exists():
            data = json.loads(declarations_path.read_text(encoding="utf-8"))
            self.build_from_declarations(data)

        if rosetta_path and rosetta_path.exists():
            self.load_rosetta(rosetta_path)

    @property
    def size(self) -> int:
        """Number of declarations in the index."""
        return len(self._declarations)

    def has_name(self, name: str) -> bool:
        """O(1) check whether a declaration name exists in the index."""
        return name in self._name_set

    def get_by_name(self, name: str) -> Declaration | None:
        """O(1) lookup of a declaration by exact name. Returns None if not found."""
        return self._name_map.get(name)

    def get_rosetta_lean(self, name: str) -> str | None:
        """Get full Lean code for a rosetta entry by item ID."""
        return self._rosetta_lean.get(name)

    def build_from_declarations(self, decls: list[dict]) -> None:
        """Build the index from a list of declaration dicts.

        Each dict should have: name, signature (optional), docstring (optional).
        Source defaults to "mathlib".
        """
        new_decls = []
        for d in decls:
            name = d.get("name", "")
            if not name:
                continue
            new_decls.append(Declaration(
                name=name,
                signature=d.get("signature", ""),
                docstring=d.get("docstring", ""),
                source=d.get("source", "mathlib"),
            ))

        self._declarations = new_decls
        self._name_set = {d.name for d in self._declarations}
        self._name_map = {d.name: d for d in self._declarations}
        self._rebuild_tfidf()

        if self._use_embeddings:
            self._rebuild_embeddings()

    def add_declarations(self, decls: list[dict]) -> None:
        """Incrementally add declarations without rebuilding the whole index.

        For TF-IDF, we rebuild (fast). For embeddings, we only embed the new entries.
        """
        new_decls = []
        for d in decls:
            name = d.get("name", "")
            if not name:
                continue
            new_decls.append(Declaration(
                name=name,
                signature=d.get("signature", ""),
                docstring=d.get("docstring", ""),
                source=d.get("source", "mathlib"),
            ))

        if not new_decls:
            return

        self._declarations.extend(new_decls)
        self._name_set.update(d.name for d in new_decls)
        self._name_map.update({d.name: d for d in new_decls})
        self._rebuild_tfidf()

        # Incremental embedding: only embed new entries
        if self._use_embeddings and self._embeddings is not None:
            texts = [d.search_text() for d in new_decls]
            new_embs = _get_embeddings(texts)
            if new_embs:
                self._embeddings.extend(new_embs)
            else:
                # API failed — fall back to TF-IDF only
                self._embeddings = None

    def load_rosetta(self, path: Path) -> None:
        """Load Rosetta Stone entries (JSONL) into the index.

        Each line should be a JSON object with at least:
          id, statement, lean_code, mathlib_identifiers (list of str)
        """
        if not path.exists():
            return

        new_decls = []
        seen_names: set[str] = {d.name for d in self._declarations}

        with open(path, encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    entry = json.loads(line)
                except json.JSONDecodeError:
                    continue

                # Extract Mathlib identifiers as individual declarations
                for ident in entry.get("mathlib_identifiers", []):
                    if ident not in seen_names:
                        seen_names.add(ident)
                        new_decls.append(Declaration(
                            name=ident,
                            signature="",  # we don't have signatures from Rosetta
                            docstring=f"Used in proof of: {entry.get('id', 'unknown')}",
                            source="rosetta",
                        ))

                # Also index the theorem itself (useful for "have we proved
                # something similar?" queries)
                item_id = entry.get("id", "")
                lean_code = entry.get("lean_code", "")
                if item_id and item_id not in seen_names:
                    seen_names.add(item_id)
                    new_decls.append(Declaration(
                        name=item_id,
                        signature=lean_code[:200],
                        docstring=entry.get("statement", ""),
                        source="rosetta",
                    ))

                # Store full lean code for warm-start retrieval
                if item_id and lean_code:
                    self._rosetta_lean[item_id] = lean_code

        if new_decls:
            self._declarations.extend(new_decls)
            self._name_set.update(d.name for d in new_decls)
            self._name_map.update({d.name: d for d in new_decls})
            self._rebuild_tfidf()
            if self._use_embeddings:
                self._rebuild_embeddings()

    def search(self, query: str, top_k: int = 10) -> list[SearchResult]:
        """Search the index for declarations matching a query.

        Tries embedding-based search first, falls back to TF-IDF.

        Args:
            query: Natural language or mathematical query string.
            top_k: Number of results to return.

        Returns:
            List of SearchResult objects, sorted by relevance (highest first).
        """
        if not self._declarations:
            return []

        # Try embedding search first
        if self._use_embeddings and self._embeddings is not None:
            results = self._search_embeddings(query, top_k)
            if results:
                return results

        # Fall back to TF-IDF
        return self._search_tfidf(query, top_k)

    def _search_tfidf(self, query: str, top_k: int) -> list[SearchResult]:
        """Search using TF-IDF cosine similarity."""
        hits = self._tfidf.query(query, top_k)
        results = []
        for idx, score in hits:
            decl = self._declarations[idx]
            results.append(SearchResult(
                name=decl.name,
                signature=decl.signature,
                docstring=decl.docstring,
                score=score,
                source=decl.source,
            ))
        return results

    def _search_embeddings(self, query: str, top_k: int) -> list[SearchResult]:
        """Search using embedding cosine similarity."""
        if self._embeddings is None:
            return []

        q_emb = _get_embeddings([query])
        if not q_emb:
            return []

        q_vec = q_emb[0]
        scores: list[tuple[int, float]] = []
        for idx, emb in enumerate(self._embeddings):
            sim = _cosine_similarity(q_vec, emb)
            scores.append((idx, sim))

        scores.sort(key=lambda x: -x[1])
        results = []
        for idx, score in scores[:top_k]:
            decl = self._declarations[idx]
            results.append(SearchResult(
                name=decl.name,
                signature=decl.signature,
                docstring=decl.docstring,
                score=score,
                source=decl.source,
            ))
        return results

    def _rebuild_tfidf(self) -> None:
        """Rebuild the TF-IDF index from all declarations."""
        texts = [d.search_text() for d in self._declarations]
        self._tfidf = TfidfIndex()
        self._tfidf.fit(texts)

    def _rebuild_embeddings(self) -> None:
        """Rebuild the embedding index from all declarations.

        Batches requests to avoid API limits. Falls back to TF-IDF
        if the API is unavailable.
        """
        if not self._declarations:
            self._embeddings = None
            return

        texts = [d.search_text() for d in self._declarations]

        # Batch in chunks of 100 to stay within API limits
        all_embeddings: list[list[float]] = []
        batch_size = 100
        for i in range(0, len(texts), batch_size):
            batch = texts[i:i + batch_size]
            embs = _get_embeddings(batch)
            if embs is None:
                # API unavailable — give up on embeddings
                self._embeddings = None
                return
            all_embeddings.extend(embs)

        self._embeddings = all_embeddings

    # ------------------------------------------------------------------
    # Persistence
    # ------------------------------------------------------------------

    def save(self, path: Path) -> None:
        """Save the index to a JSON file.

        Saves declarations and TF-IDF state. Embeddings are NOT persisted
        (they can be rebuilt from the declarations, and the vectors are
        large). This keeps the index file compact and portable.
        """
        path.parent.mkdir(parents=True, exist_ok=True)
        data = {
            "declarations": [
                {
                    "name": d.name,
                    "signature": d.signature,
                    "docstring": d.docstring,
                    "source": d.source,
                }
                for d in self._declarations
            ],
            "tfidf": self._tfidf.to_dict(),
        }
        path.write_text(json.dumps(data), encoding="utf-8")

    def load(self, path: Path) -> None:
        """Load a pre-built index from a JSON file.

        Restores declarations and TF-IDF state. Embeddings can optionally
        be rebuilt after loading by calling _rebuild_embeddings().
        """
        if not path.exists():
            return

        data = json.loads(path.read_text(encoding="utf-8"))

        self._declarations = [
            Declaration(
                name=d["name"],
                signature=d.get("signature", ""),
                docstring=d.get("docstring", ""),
                source=d.get("source", "mathlib"),
            )
            for d in data.get("declarations", [])
        ]
        self._name_set = {d.name for d in self._declarations}
        self._name_map = {d.name: d for d in self._declarations}

        tfidf_data = data.get("tfidf")
        if tfidf_data:
            self._tfidf = TfidfIndex.from_dict(tfidf_data)
        else:
            self._rebuild_tfidf()

        # Embeddings are not persisted — rebuild if needed
        self._embeddings = None

    # ------------------------------------------------------------------
    # Prompt formatting
    # ------------------------------------------------------------------

    def format_hint_section(self, query: str, top_k: int = 10) -> str:
        """Search and format results as a prompt section for the translator.

        Returns empty string if the index is empty or no results found.

        Example output:
            ## Relevant Mathlib lemmas
            The following Mathlib declarations may be useful. Use these EXACT
            names — do NOT guess or modify them.
            - `Nat.add_comm` : ∀ (n m : ℕ), n + m = m + n
            - `Nat.add_assoc` : ∀ (n m k : ℕ), n + m + k = n + (m + k)
        """
        results = self.search(query, top_k=top_k)
        if not results:
            return ""

        lines = [
            "## Relevant Mathlib lemmas",
            "The following Mathlib declarations may be useful. Use these EXACT "
            "names — do NOT guess or modify them.\n",
        ]
        for r in results:
            if r.signature:
                lines.append(f"- `{r.name}` : {r.signature}")
            else:
                lines.append(f"- `{r.name}`")
            if r.docstring:
                # Keep docstrings short — one line max
                doc_short = r.docstring.split("\n")[0][:120]
                lines.append(f"  {doc_short}")

        return "\n".join(lines)
