"""Embedding-based similarity search over Rosetta Stone and pipeline data.

Uses sentence-transformers (all-MiniLM-L6-v2, ~80MB) for local cosine similarity
search. Eliminates most Claude Haiku calls in the Librarian by providing
threshold-based routing:
  - score >= THRESHOLD_HIGH → auto-match, no LLM needed
  - score >= THRESHOLD_LOW  → borderline, verify with LLM
  - score < THRESHOLD_LOW   → no match
"""

import json
from pathlib import Path

import numpy as np

from .librarian_index import LibrarianIndex, IndexEntry

PROJECT_ROOT = Path(__file__).resolve().parents[2]
EMBEDDINGS_PATH = PROJECT_ROOT / "outputs" / "embeddings.npy"
EMBEDDINGS_META_PATH = PROJECT_ROOT / "outputs" / "embeddings_meta.json"

MODEL_NAME = "all-MiniLM-L6-v2"
THRESHOLD_HIGH = 0.85
THRESHOLD_LOW = 0.70


def _load_model():
    """Lazy-load the sentence transformer model."""
    from sentence_transformers import SentenceTransformer
    return SentenceTransformer(MODEL_NAME)


class EmbeddingIndex:
    """Embedding-based search index for mathematical theorem lookup."""

    def __init__(
        self,
        embeddings_path: Path | None = None,
        meta_path: Path | None = None,
    ):
        self.embeddings_path = embeddings_path or EMBEDDINGS_PATH
        self.meta_path = meta_path or EMBEDDINGS_META_PATH
        self._model = None
        self._embeddings: np.ndarray | None = None
        self._entry_ids: list[str] = []
        self._loaded = False

    @property
    def model(self):
        if self._model is None:
            self._model = _load_model()
        return self._model

    def load(self) -> bool:
        """Load precomputed embeddings from disk."""
        if not self.embeddings_path.exists() or not self.meta_path.exists():
            return False

        try:
            self._embeddings = np.load(str(self.embeddings_path))
            meta = json.loads(self.meta_path.read_text(encoding="utf-8"))
            self._entry_ids = meta.get("entry_ids", [])

            if len(self._entry_ids) != self._embeddings.shape[0]:
                print(f"  [embedding-index] Shape mismatch: {len(self._entry_ids)} ids vs {self._embeddings.shape[0]} embeddings")
                return False

            self._loaded = True
            return True
        except Exception as e:
            print(f"  [embedding-index] Failed to load: {e}")
            return False

    def build(self, librarian_index: LibrarianIndex, batch_size: int = 256) -> int:
        """Build embeddings from a LibrarianIndex. Returns count of entries embedded."""
        librarian_index._ensure_loaded()
        entries = librarian_index.entries
        if not entries:
            print("  [embedding-index] No entries to embed")
            return 0

        print(f"  [embedding-index] Encoding {len(entries)} entries with {MODEL_NAME}...")

        # Build text corpus: NL statement + lean name (for context)
        texts = []
        self._entry_ids = []
        for entry in entries:
            text = entry.nl_statement
            if entry.lean_name:
                text += f" ({entry.lean_name.replace('_', ' ')})"
            texts.append(text)
            self._entry_ids.append(entry.id)

        # Encode in batches
        self._embeddings = self.model.encode(
            texts,
            batch_size=batch_size,
            show_progress_bar=True,
            normalize_embeddings=True,  # Pre-normalize for cosine similarity via dot product
        )

        self._loaded = True
        print(f"  [embedding-index] Encoded {len(entries)} entries, shape: {self._embeddings.shape}")
        return len(entries)

    def save(self):
        """Persist embeddings and metadata to disk."""
        if self._embeddings is None:
            return

        self.embeddings_path.parent.mkdir(parents=True, exist_ok=True)
        np.save(str(self.embeddings_path), self._embeddings)

        meta = {
            "model": MODEL_NAME,
            "entry_count": len(self._entry_ids),
            "embedding_dim": self._embeddings.shape[1],
            "entry_ids": self._entry_ids,
        }
        self.meta_path.write_text(json.dumps(meta), encoding="utf-8")

        size_mb = self.embeddings_path.stat().st_size / (1024 * 1024)
        print(f"  [embedding-index] Saved {len(self._entry_ids)} embeddings ({size_mb:.1f} MB)")

    def search(
        self,
        query: str,
        top_k: int = 10,
        entries: list[IndexEntry] | None = None,
    ) -> list[tuple[IndexEntry | str, float]]:
        """Search for similar entries by embedding cosine similarity.

        Returns list of (entry_or_id, similarity_score) sorted descending.
        If `entries` is provided, returns (IndexEntry, score) tuples.
        Otherwise returns (entry_id, score) tuples.
        """
        if not self._loaded or self._embeddings is None:
            if not self.load():
                return []

        # Encode query
        query_emb = self.model.encode(
            [query], normalize_embeddings=True
        )[0]

        # Cosine similarity via dot product (embeddings are pre-normalized)
        scores = self._embeddings @ query_emb

        # Get top-k indices
        if len(scores) <= top_k:
            top_indices = np.argsort(scores)[::-1]
        else:
            # Partial sort for efficiency
            top_indices = np.argpartition(scores, -top_k)[-top_k:]
            top_indices = top_indices[np.argsort(scores[top_indices])[::-1]]

        results = []
        for idx in top_indices:
            score = float(scores[idx])
            if score <= 0:
                break
            if entries and idx < len(entries):
                results.append((entries[idx], score))
            else:
                entry_id = self._entry_ids[idx] if idx < len(self._entry_ids) else f"unknown:{idx}"
                results.append((entry_id, score))

        return results

    @property
    def is_available(self) -> bool:
        """Check if embeddings are loaded or loadable."""
        if self._loaded:
            return True
        return self.embeddings_path.exists() and self.meta_path.exists()

    def stats(self) -> dict:
        """Return embedding index statistics."""
        if not self._loaded:
            self.load()
        return {
            "loaded": self._loaded,
            "entry_count": len(self._entry_ids),
            "embedding_dim": self._embeddings.shape[1] if self._embeddings is not None else 0,
            "embeddings_file": str(self.embeddings_path),
            "file_exists": self.embeddings_path.exists(),
            "file_size_mb": (
                self.embeddings_path.stat().st_size / (1024 * 1024)
                if self.embeddings_path.exists() else 0
            ),
        }


def build_embeddings_cli():
    """CLI entry point for building embeddings."""
    print("=== Building Embedding Index ===\n")

    lib_index = LibrarianIndex()
    if not lib_index.load():
        print("No librarian index found. Building from source data...")
        lib_index.build()
        lib_index.save()

    emb_index = EmbeddingIndex()
    count = emb_index.build(lib_index)
    emb_index.save()
    print(f"\nDone: {count} entries embedded")
