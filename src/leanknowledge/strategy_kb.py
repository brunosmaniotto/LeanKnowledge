"""Strategy Knowledge Base — the system's accumulated intuition.

Records what proof strategies, tactics, and error patterns work for which types of theorems.
"""

import json
from dataclasses import dataclass, field, asdict
from pathlib import Path
from collections import Counter


@dataclass
class StrategyEntry:
    """One entry per verified proof."""
    theorem_id: str
    domain: str
    mathematical_objects: list[str]       # e.g. ["preference_relation", "compact_set"]
    proof_strategies: list[str]           # e.g. ["direct", "compactness_argument"]
    lean_tactics_used: list[str]          # e.g. ["intro", "have", "exact"]
    lean_tactics_failed: list[str]        # tactics that didn't work
    difficulty: str                       # "easy", "medium", "hard"
    iterations_to_compile: int
    proof_revisions: int
    error_types_encountered: list[str]    # e.g. ["tactic_failure", "type_mismatch"]
    dependencies_used: list[str]          # Lean declaration names used
    source: str                           # e.g. "MWG Chapter 3"


class StrategyKB:
    """JSON-backed strategy knowledge base.

    Lazy-loads on first access to avoid slow startup when the KB is large.
    """

    def __init__(self, path: Path = Path("strategy_kb.json")):
        self.path = path
        self._entries: list[StrategyEntry] | None = None

        # Check for SQLite database
        self._db_path = path.parent / "leanknowledge.db"
        self._use_sqlite = self._db_path.exists()
        if self._use_sqlite:
            from .storage import StrategyStore
            self._store = StrategyStore(self._db_path)

    @property
    def entries(self) -> list[StrategyEntry]:
        if self._entries is None:
            self._entries = []
            if self._use_sqlite or self.path.exists():
                self.load()
        return self._entries

    @entries.setter
    def entries(self, value: list[StrategyEntry]):
        self._entries = value

    def add(self, entry: StrategyEntry) -> None:
        """Add a new entry after a proof is verified."""
        self.entries.append(entry)
        # Incremental: append to JSON and single-row insert to SQLite
        self._save_json()
        if self._use_sqlite:
            self._store.add(entry)

    def bulk_add(self, entries: list[StrategyEntry]) -> None:
        """Add multiple entries and save once."""
        self.entries.extend(entries)
        self.save()

    def query_by_objects(self, objects: list[str], top_k: int = 5) -> list[StrategyEntry]:
        """Find entries involving these mathematical objects. Rank by overlap count."""
        if not objects:
            return []

        scored_entries = []
        target_set = set(objects)

        for entry in self.entries:
            entry_objects = set(entry.mathematical_objects)
            overlap = len(target_set.intersection(entry_objects))
            if overlap > 0:
                scored_entries.append((overlap, entry))

        # Sort by overlap (descending)
        scored_entries.sort(key=lambda x: x[0], reverse=True)
        
        return [entry for _, entry in scored_entries[:top_k]]

    def query_by_strategy(self, strategy: str, domain: str | None = None) -> list[StrategyEntry]:
        """Find entries using this proof strategy, optionally filtered by domain."""
        results = []
        for entry in self.entries:
            if strategy in entry.proof_strategies:
                if domain is None or entry.domain == domain:
                    results.append(entry)
        return results

    def query_by_error(self, error_type: str, objects: list[str] | None = None) -> list[StrategyEntry]:
        """Find entries that encountered this error type. For repair guidance.
        
        If objects are provided, rank by object overlap.
        """
        candidates = [e for e in self.entries if error_type in e.error_types_encountered]
        
        if not objects:
            return candidates

        # Rank by object overlap if objects provided
        target_set = set(objects)
        scored_candidates = []
        for entry in candidates:
            entry_objects = set(entry.mathematical_objects)
            overlap = len(target_set.intersection(entry_objects))
            scored_candidates.append((overlap, entry))
        
        scored_candidates.sort(key=lambda x: x[0], reverse=True)
        return [entry for _, entry in scored_candidates]

    def strategy_success_rates(self, objects: list[str]) -> dict[str, float]:
        """For theorems involving these objects, return {strategy: success_rate}.
        
        Success rate definition: (entries with this strategy that compiled in <= 3 iterations) / (all entries with this strategy)
        Only considers entries that share at least one object.
        """
        if not objects:
            return {}

        target_set = set(objects)
        relevant_entries = []
        for entry in self.entries:
            entry_objects = set(entry.mathematical_objects)
            if not target_set.isdisjoint(entry_objects):
                relevant_entries.append(entry)

        if not relevant_entries:
            return {}

        strategy_counts: dict[str, int] = Counter()
        strategy_successes: dict[str, int] = Counter()

        for entry in relevant_entries:
            # An entry might use multiple strategies (though usually one main one)
            for strategy in entry.proof_strategies:
                strategy_counts[strategy] += 1
                # Success criterion: <= 3 iterations
                if entry.iterations_to_compile <= 3:
                    strategy_successes[strategy] += 1

        rates = {}
        for strategy, total in strategy_counts.items():
            success_count = strategy_successes[strategy]
            rates[strategy] = success_count / total

        return rates

    def tactic_patterns(self, strategy: str, domain: str | None = None) -> list[list[str]]:
        """Return tactic sequences that compiled for this strategy+domain."""
        matching_entries = self.query_by_strategy(strategy, domain)
        # Return the tactic sequences from these entries
        return [entry.lean_tactics_used for entry in matching_entries if entry.lean_tactics_used]

    def _save_json(self) -> None:
        """Write all entries to JSON (compact format)."""
        data = [asdict(e) for e in self.entries]
        self.path.write_text(json.dumps(data, separators=(",", ":")), encoding="utf-8")

    def save(self) -> None:
        """Full persist to JSON + SQLite bulk (used by bulk_add)."""
        self._save_json()
        if self._use_sqlite:
            self._store.save_all(self.entries)

    def load(self) -> None:
        """Load from JSON or SQLite."""
        if self._use_sqlite:
            self._entries = self._store.load_all()
            return

        if not self.path.exists():
            return
        try:
            raw_data = json.loads(self.path.read_text(encoding="utf-8"))
            self.entries = [StrategyEntry(**item) for item in raw_data]
        except (json.JSONDecodeError, TypeError):
            # Handle empty or corrupted file gracefully
            self.entries = []
