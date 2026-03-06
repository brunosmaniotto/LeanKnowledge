"""SQLite storage backend for Backlog and Strategy KB.

Migrates from JSON files while maintaining backward compatibility.
If a .json file exists but no .db file, auto-migrates on first access.
"""

import json
import sqlite3
from pathlib import Path
from contextlib import contextmanager
from dataclasses import asdict


DB_NAME = "leanknowledge.db"


@contextmanager
def _connect(db_path: Path):
    """Context manager for SQLite connections with WAL mode."""
    conn = sqlite3.connect(str(db_path))
    conn.execute("PRAGMA journal_mode=WAL")
    conn.execute("PRAGMA foreign_keys=ON")
    conn.row_factory = sqlite3.Row
    try:
        yield conn
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


def init_db(db_path: Path):
    """Create tables if they don't exist."""
    with _connect(db_path) as conn:
        conn.execute("""
            CREATE TABLE IF NOT EXISTS backlog (
                item_id TEXT PRIMARY KEY,
                data TEXT NOT NULL,  -- JSON blob of BacklogEntry
                status TEXT NOT NULL,
                domain TEXT NOT NULL,
                priority_score INTEGER DEFAULT 0,
                attempts INTEGER DEFAULT 0,
                added_at TEXT,
                completed_at TEXT
            )
        """)
        conn.execute("""
            CREATE INDEX IF NOT EXISTS idx_backlog_status ON backlog(status)
        """)
        conn.execute("""
            CREATE INDEX IF NOT EXISTS idx_backlog_domain ON backlog(domain)
        """)
        conn.execute("""
            CREATE TABLE IF NOT EXISTS strategy_kb (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                theorem_id TEXT NOT NULL,
                domain TEXT NOT NULL,
                data TEXT NOT NULL,  -- JSON blob of StrategyEntry
                difficulty TEXT,
                iterations INTEGER
            )
        """)
        conn.execute("""
            CREATE INDEX IF NOT EXISTS idx_strategy_domain ON strategy_kb(domain)
        """)
        conn.execute("""
            CREATE INDEX IF NOT EXISTS idx_strategy_theorem ON strategy_kb(theorem_id)
        """)


class BacklogStore:
    """SQLite-backed backlog storage."""

    def __init__(self, db_path: Path):
        self.db_path = db_path
        init_db(db_path)

    def save_all(self, entries: dict[str, "BacklogEntry"]):
        """Bulk save all entries (used for migration and full refreshes)."""
        with _connect(self.db_path) as conn:
            conn.execute("DELETE FROM backlog")
            for item_id, entry in entries.items():
                conn.execute(
                    "INSERT INTO backlog (item_id, data, status, domain, priority_score, attempts, added_at, completed_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
                    (item_id, entry.model_dump_json(), entry.status.value, entry.domain.value,
                     entry.priority_score, entry.attempts,
                     entry.added_at.isoformat() if entry.added_at else None,
                     entry.completed_at.isoformat() if entry.completed_at else None)
                )

    def load_all(self) -> dict[str, "BacklogEntry"]:
        """Load all entries."""
        from .schemas import BacklogEntry
        entries = {}
        with _connect(self.db_path) as conn:
            for row in conn.execute("SELECT item_id, data FROM backlog"):
                entries[row["item_id"]] = BacklogEntry.model_validate_json(row["data"])
        return entries

    def upsert(self, item_id: str, entry: "BacklogEntry"):
        """Insert or update a single entry."""
        with _connect(self.db_path) as conn:
            conn.execute(
                """INSERT OR REPLACE INTO backlog
                   (item_id, data, status, domain, priority_score, attempts, added_at, completed_at)
                   VALUES (?, ?, ?, ?, ?, ?, ?, ?)""",
                (item_id, entry.model_dump_json(), entry.status.value, entry.domain.value,
                 entry.priority_score, entry.attempts,
                 entry.added_at.isoformat() if entry.added_at else None,
                 entry.completed_at.isoformat() if entry.completed_at else None)
            )

    def count_by_status(self) -> dict[str, int]:
        """Fast status counts without loading all entries."""
        with _connect(self.db_path) as conn:
            counts = {}
            for row in conn.execute("SELECT status, COUNT(*) as cnt FROM backlog GROUP BY status"):
                counts[row["status"]] = row["cnt"]
            return counts


class StrategyStore:
    """SQLite-backed strategy KB storage."""

    def __init__(self, db_path: Path):
        self.db_path = db_path
        init_db(db_path)

    def save_all(self, entries: list):
        """Bulk save all entries (used for migration)."""
        with _connect(self.db_path) as conn:
            conn.execute("DELETE FROM strategy_kb")
            for entry in entries:
                data = json.dumps(asdict(entry), separators=(",", ":"))
                conn.execute(
                    "INSERT INTO strategy_kb (theorem_id, domain, data, difficulty, iterations) VALUES (?, ?, ?, ?, ?)",
                    (entry.theorem_id, entry.domain, data, entry.difficulty, entry.iterations_to_compile)
                )

    def load_all(self) -> list:
        """Load all entries."""
        from .strategy_kb import StrategyEntry
        entries = []
        with _connect(self.db_path) as conn:
            for row in conn.execute("SELECT data FROM strategy_kb"):
                entries.append(StrategyEntry(**json.loads(row["data"])))
        return entries

    def add(self, entry) -> None:
        """Add a single entry."""
        data = json.dumps(asdict(entry), separators=(",", ":"))
        with _connect(self.db_path) as conn:
            conn.execute(
                "INSERT INTO strategy_kb (theorem_id, domain, data, difficulty, iterations) VALUES (?, ?, ?, ?, ?)",
                (entry.theorem_id, entry.domain, data, entry.difficulty, entry.iterations_to_compile)
            )

    def query_by_domain(self, domain: str) -> list:
        """Fast domain-filtered query."""
        from .strategy_kb import StrategyEntry
        entries = []
        with _connect(self.db_path) as conn:
            for row in conn.execute("SELECT data FROM strategy_kb WHERE domain = ?", (domain,)):
                entries.append(StrategyEntry(**json.loads(row["data"])))
        return entries


def migrate_json_to_sqlite(
    backlog_json: Path | None = None,
    strategy_json: Path | None = None,
    db_path: Path | None = None,
):
    """One-time migration from JSON files to SQLite.

    Usage:
        python -m leanknowledge.storage  # auto-detects files in project root
    """
    from .schemas import BacklogEntry
    from .strategy_kb import StrategyEntry

    project_root = Path(__file__).resolve().parents[2]
    db_path = db_path or (project_root / DB_NAME)

    init_db(db_path)

    # Migrate backlog
    bl_path = backlog_json or (project_root / "backlog.json")
    if bl_path.exists():
        print(f"Migrating backlog from {bl_path}...")
        raw = json.loads(bl_path.read_text())
        entries = {k: BacklogEntry.model_validate(v) for k, v in raw.items()}
        store = BacklogStore(db_path)
        store.save_all(entries)
        print(f"  Migrated {len(entries)} backlog entries.")

    # Migrate strategy KB
    sk_path = strategy_json or (project_root / "strategy_kb.json")
    if sk_path.exists():
        print(f"Migrating strategy KB from {sk_path}...")
        raw = json.loads(sk_path.read_text())
        kb_entries = [StrategyEntry(**item) for item in raw]
        store = StrategyStore(db_path)
        store.save_all(kb_entries)
        print(f"  Migrated {len(kb_entries)} strategy entries.")

    print(f"Migration complete: {db_path}")


if __name__ == "__main__":
    migrate_json_to_sqlite()
