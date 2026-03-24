"""Failure dashboard — reads pipeline output and displays statistics.

Pure data analysis, no LLM calls. Reads backlog JSON, triple files,
failure records, and work queue to produce a human-readable summary
of pipeline progress and error patterns.

Usage:
    python -m leanknowledge dashboard [output_dir]
"""

import json
import logging
import re
import statistics
from collections import Counter
from datetime import datetime, timedelta
from pathlib import Path

from .backlog import BacklogEntry, BacklogStatus
from .lean.errors import classify_error, parse_compiler_output
from .schemas import ErrorCategory

logger = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# Data loading
# ---------------------------------------------------------------------------

def _load_json(path: Path) -> dict | list | None:
    """Load a JSON file, returning None on error."""
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception as e:
        logger.warning("Could not load %s: %s", path, e)
        return None


def load_backlog_entries(output_dir: Path) -> list[BacklogEntry]:
    """Load backlog entries from all backlog.json files under output_dir.

    Handles both flat layout (output_dir/backlog.json) and worker layout
    (output_dir/worker_*/backlog.json).
    """
    entries: dict[str, BacklogEntry] = {}

    # Flat layout
    flat = output_dir / "backlog.json"
    if flat.is_file():
        data = _load_json(flat)
        if isinstance(data, dict):
            for item_id, entry_data in data.items():
                try:
                    entries[item_id] = BacklogEntry.model_validate(entry_data)
                except Exception as e:
                    logger.warning("Malformed backlog entry %s: %s", item_id, e)

    # Worker layout
    for worker_dir in sorted(output_dir.glob("worker_*")):
        if not worker_dir.is_dir():
            continue
        bl = worker_dir / "backlog.json"
        if not bl.is_file():
            continue
        data = _load_json(bl)
        if not isinstance(data, dict):
            continue
        for item_id, entry_data in data.items():
            try:
                entries[item_id] = BacklogEntry.model_validate(entry_data)
            except Exception as e:
                logger.warning("Malformed backlog entry %s: %s", item_id, e)

    return list(entries.values())


def load_triples(output_dir: Path) -> list[dict]:
    """Load all translation triple files.

    Each triple file is a JSON array of attempt records.
    Returns a flat list of all individual attempt dicts.
    """
    attempts: list[dict] = []

    # Collect from all triples dirs (flat + worker)
    triple_dirs = []
    flat = output_dir / "triples"
    if flat.is_dir():
        triple_dirs.append(flat)
    for worker_dir in sorted(output_dir.glob("worker_*")):
        td = worker_dir / "triples"
        if td.is_dir():
            triple_dirs.append(td)

    for td in triple_dirs:
        for f in sorted(td.glob("*.json")):
            data = _load_json(f)
            if isinstance(data, list):
                for item in data:
                    if isinstance(item, dict):
                        attempts.append(item)
            elif isinstance(data, dict):
                attempts.append(data)

    return attempts


def load_failure_records(output_dir: Path) -> list[dict]:
    """Load all failure record files."""
    records: list[dict] = []

    failure_dirs = []
    flat = output_dir / "failures"
    if flat.is_dir():
        failure_dirs.append(flat)
    for worker_dir in sorted(output_dir.glob("worker_*")):
        fd = worker_dir / "failures"
        if fd.is_dir():
            failure_dirs.append(fd)

    for fd in failure_dirs:
        for f in sorted(fd.glob("*.json")):
            data = _load_json(f)
            if isinstance(data, dict):
                records.append(data)

    return records


def load_work_queue(output_dir: Path) -> list[dict]:
    """Load work_queue.json if it exists (multi-worker runs)."""
    wq = output_dir / "work_queue.json"
    if not wq.is_file():
        return []
    data = _load_json(wq)
    if isinstance(data, dict) and "items" in data:
        return data["items"]
    if isinstance(data, list):
        return data
    return []


def load_results_summaries(output_dir: Path) -> list[dict]:
    """Load results_summary.json files (worker runs store per-item results).

    Returns a flat list of per-item result dicts with keys:
    id, success, attempts, lean_file, error.
    """
    items: list[dict] = []

    # Flat layout
    flat = output_dir / "results_summary.json"
    if flat.is_file():
        data = _load_json(flat)
        if isinstance(data, dict) and "items" in data:
            items.extend(data["items"])

    # Worker layout
    for worker_dir in sorted(output_dir.glob("worker_*")):
        if not worker_dir.is_dir():
            continue
        rs = worker_dir / "results_summary.json"
        if not rs.is_file():
            continue
        data = _load_json(rs)
        if isinstance(data, dict) and "items" in data:
            items.extend(data["items"])

    return items


# ---------------------------------------------------------------------------
# Statistics computation
# ---------------------------------------------------------------------------

class DashboardStats:
    """Container for all computed dashboard statistics."""

    def __init__(
        self,
        entries: list[BacklogEntry],
        triples: list[dict],
        failures: list[dict],
        work_queue: list[dict],
        output_dir: Path,
        results_summaries: list[dict] | None = None,
    ):
        self.entries = entries
        self.triples = triples
        self.failures = failures
        self.work_queue = work_queue
        self.output_dir = output_dir
        self.results_summaries = results_summaries or []
        self._compute()

    def _compute(self):
        # --- Status counts ---
        self.status_counts: Counter = Counter()
        for e in self.entries:
            self.status_counts[e.status.value] += 1

        self.total = len(self.entries)
        self.completed = self.status_counts.get("completed", 0)
        self.failed = self.status_counts.get("failed", 0)
        self.axiomatized = self.status_counts.get("axiomatized", 0)
        self.in_progress = self.status_counts.get("in_progress", 0)
        self.ready = self.status_counts.get("ready", 0)
        self.pending = self.status_counts.get("pending", 0)

        # "Attempted" = completed + failed + axiomatized + in_progress
        self.attempted = self.completed + self.failed + self.axiomatized + self.in_progress

        # --- Success rate ---
        self.success_rate = (
            (self.completed / self.attempted * 100) if self.attempted > 0 else 0.0
        )

        # --- Attempts per success ---
        # Prefer results_summary data (has accurate per-item attempt counts)
        # over backlog attempts (which only counts mark_in_progress calls).
        self.attempts_per_success: list[int] = []
        if self.results_summaries:
            for item in self.results_summaries:
                if item.get("success") and item.get("attempts", 0) > 0:
                    self.attempts_per_success.append(item["attempts"])
        else:
            for e in self.entries:
                if e.status == BacklogStatus.COMPLETED and e.attempts > 0:
                    self.attempts_per_success.append(e.attempts)

        self.avg_attempts = (
            statistics.mean(self.attempts_per_success)
            if self.attempts_per_success else 0.0
        )
        self.median_attempts = (
            statistics.median(self.attempts_per_success)
            if self.attempts_per_success else 0.0
        )

        # --- Error breakdown from triples ---
        self.error_category_counts: Counter = Counter()
        self.error_messages: Counter = Counter()
        self.total_errors = 0

        for t in self.triples:
            if t.get("compiled", False):
                continue
            compiler_output = t.get("compiler_output", "")
            if not compiler_output:
                continue
            errors = parse_compiler_output(compiler_output)
            for err in errors:
                self.error_category_counts[err.category.value] += 1
                self.total_errors += 1
                # Normalize the message for grouping (first line, truncated)
                msg = err.message.split("\n")[0].strip()[:100]
                if msg:
                    self.error_messages[msg] += 1

        # --- Hallucinated identifiers ---
        self.hallucinated_identifiers: Counter = Counter()
        _ident_pattern = re.compile(
            r"(?:unknown (?:identifier|constant)|not found)[^`]*[`'\"]([A-Za-z_][\w.]*)[`'\"]",
            re.IGNORECASE,
        )
        for t in self.triples:
            if t.get("compiled", False):
                continue
            out = t.get("compiler_output", "")
            if not out:
                continue
            for m in _ident_pattern.finditer(out):
                self.hallucinated_identifiers[m.group(1)] += 1

        # --- Category performance ---
        self.category_stats: dict[str, dict] = {}
        # Use section field from backlog entries as category proxy
        for e in self.entries:
            section = e.item.section or "Unknown"
            if section not in self.category_stats:
                self.category_stats[section] = {
                    "attempted": 0, "completed": 0, "failed": 0,
                }
            if e.status in (BacklogStatus.COMPLETED, BacklogStatus.FAILED):
                self.category_stats[section]["attempted"] += 1
                if e.status == BacklogStatus.COMPLETED:
                    self.category_stats[section]["completed"] += 1
                else:
                    self.category_stats[section]["failed"] += 1

        # --- Model performance ---
        self.model_counts: Counter = Counter()
        self.model_successes: Counter = Counter()
        for t in self.triples:
            model = t.get("model", "unknown")
            self.model_counts[model] += 1
            if t.get("compiled", False):
                self.model_successes[model] += 1

        # --- Timeline / throughput ---
        self.timestamps: list[datetime] = []
        for e in self.entries:
            if e.completed_at:
                self.timestamps.append(e.completed_at)
            if e.added_at:
                self.timestamps.append(e.added_at)

        self.earliest: datetime | None = None
        self.latest: datetime | None = None
        self.elapsed: timedelta | None = None

        if self.timestamps:
            self.earliest = min(self.timestamps)
            self.latest = max(self.timestamps)
            self.elapsed = self.latest - self.earliest

        # Throughput (theorems completed per minute)
        completion_times: list[datetime] = []
        for e in self.entries:
            if e.status == BacklogStatus.COMPLETED and e.completed_at:
                completion_times.append(e.completed_at)

        self.throughput_per_min = 0.0
        if completion_times and self.elapsed and self.elapsed.total_seconds() > 0:
            elapsed_min = self.elapsed.total_seconds() / 60
            self.throughput_per_min = len(completion_times) / elapsed_min

        # Estimated time remaining
        self.est_remaining: timedelta | None = None
        remaining_count = self.total - self.attempted
        if self.throughput_per_min > 0 and remaining_count > 0:
            remaining_min = remaining_count / self.throughput_per_min
            self.est_remaining = timedelta(minutes=remaining_min)

        # --- Failure cause breakdown (from failure records) ---
        self.failure_causes: Counter = Counter()
        for rec in self.failures:
            cause = rec.get("cause", "unknown")
            self.failure_causes[cause] += 1


# ---------------------------------------------------------------------------
# Rendering
# ---------------------------------------------------------------------------

def _pct(n: int, total: int) -> str:
    if total == 0:
        return "0.0%"
    return f"{n / total * 100:.1f}%"


def _bar(n: int, total: int, width: int = 30) -> str:
    """Simple ASCII progress bar."""
    if total == 0:
        return "[" + " " * width + "]"
    filled = int(n / total * width)
    return "[" + "#" * filled + " " * (width - filled) + "]"


def format_dashboard(stats: DashboardStats) -> str:
    """Render the dashboard as a plain-text string."""
    lines: list[str] = []

    # Header
    lines.append("=" * 60)
    lines.append("  LeanKnowledge Pipeline Dashboard")
    lines.append("=" * 60)
    lines.append(f"Run: {stats.output_dir}")

    # Run status
    if stats.in_progress > 0 or stats.ready > 0 or stats.pending > 0:
        status_label = "IN PROGRESS"
    elif stats.total == 0:
        status_label = "EMPTY"
    else:
        status_label = "COMPLETE"

    elapsed_str = ""
    if stats.elapsed:
        total_sec = int(stats.elapsed.total_seconds())
        hours, remainder = divmod(total_sec, 3600)
        minutes, _ = divmod(remainder, 60)
        elapsed_str = f" ({hours}h {minutes}m elapsed)"

    lines.append(f"Status: {status_label}{elapsed_str}")
    lines.append("")

    # Progress
    lines.append(f"Progress: {stats.attempted}/{stats.total} "
                 f"({_pct(stats.attempted, stats.total)})")
    lines.append(f"  {_bar(stats.attempted, stats.total)}")
    lines.append(f"  Proved:      {stats.completed:>5} ({_pct(stats.completed, stats.attempted)})")
    lines.append(f"  Failed:      {stats.failed:>5} ({_pct(stats.failed, stats.attempted)})")
    if stats.axiomatized > 0:
        lines.append(f"  Axiomatized: {stats.axiomatized:>5} ({_pct(stats.axiomatized, stats.attempted)})")
    if stats.in_progress > 0:
        lines.append(f"  In Progress: {stats.in_progress:>5}")
    remaining = stats.total - stats.attempted
    if remaining > 0:
        lines.append(f"  Remaining:   {remaining:>5}")
    lines.append("")

    # Attempts stats
    if stats.attempts_per_success:
        lines.append(f"Attempts per success: avg {stats.avg_attempts:.1f}, "
                     f"median {stats.median_attempts:.0f}")
        lines.append("")

    # Error breakdown
    if stats.error_category_counts:
        lines.append(f"Error Breakdown ({stats.failed} failures, "
                     f"{stats.total_errors} total errors):")
        for cat, count in stats.error_category_counts.most_common():
            lines.append(f"  {cat:<16} {count:>5} ({_pct(count, stats.total_errors)})")
        lines.append("")

    # Top error messages
    if stats.error_messages:
        lines.append("Top Errors:")
        for i, (msg, count) in enumerate(stats.error_messages.most_common(10), 1):
            display = msg if len(msg) <= 60 else msg[:57] + "..."
            lines.append(f"  {i:>2}. {display} ({count}x)")
        lines.append("")

    # Hallucinated identifiers
    if stats.hallucinated_identifiers:
        lines.append("Top Hallucinated Identifiers:")
        for i, (ident, count) in enumerate(
            stats.hallucinated_identifiers.most_common(10), 1
        ):
            lines.append(f"  {i:>2}. {ident} ({count}x)")
        lines.append("")

    # Category performance
    # Sort by success rate ascending (worst first), filter to >= 2 attempted
    cat_rows = []
    for section, s in stats.category_stats.items():
        if s["attempted"] >= 2:
            rate = s["completed"] / s["attempted"] * 100 if s["attempted"] else 0
            cat_rows.append((section, s["completed"], s["attempted"], rate))

    if cat_rows:
        cat_rows.sort(key=lambda r: r[3])
        lines.append("Category Performance (worst first, min 2 attempted):")
        for section, comp, att, rate in cat_rows[:15]:
            label = section if len(section) <= 30 else section[:27] + "..."
            lines.append(f"  {label:<32} {comp:>3}/{att:<3} ({rate:>5.1f}%)")
        if len(cat_rows) > 15:
            lines.append(f"  ... and {len(cat_rows) - 15} more categories")
        lines.append("")

    # Model performance
    if stats.model_counts:
        lines.append("Model Performance:")
        for model, total in stats.model_counts.most_common():
            succ = stats.model_successes.get(model, 0)
            lines.append(f"  {model:<40} {succ:>4}/{total:<4} "
                         f"({_pct(succ, total)})")
        lines.append("")

    # Failure causes (from failure records)
    if stats.failure_causes:
        lines.append("Failure Causes:")
        for cause, count in stats.failure_causes.most_common():
            lines.append(f"  {cause:<25} {count:>5}")
        lines.append("")

    # Throughput
    if stats.throughput_per_min > 0:
        lines.append(f"Throughput: {stats.throughput_per_min:.1f} theorems/min")
        if stats.est_remaining:
            rem_sec = int(stats.est_remaining.total_seconds())
            rem_h, rem_rem = divmod(rem_sec, 3600)
            rem_m, _ = divmod(rem_rem, 60)
            lines.append(f"Est. remaining: ~{rem_h}h {rem_m}m")
    elif stats.elapsed and stats.attempted > 0:
        elapsed_min = stats.elapsed.total_seconds() / 60
        if elapsed_min > 0:
            rate = stats.attempted / elapsed_min
            lines.append(f"Throughput: {rate:.1f} theorems/min (attempted)")

    lines.append("")
    lines.append("=" * 60)
    return "\n".join(lines)


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

def run_dashboard(output_dir: Path) -> str:
    """Load data from output_dir and return formatted dashboard string."""
    entries = load_backlog_entries(output_dir)
    triples = load_triples(output_dir)
    failures = load_failure_records(output_dir)
    work_queue = load_work_queue(output_dir)
    results_summaries = load_results_summaries(output_dir)

    stats = DashboardStats(
        entries, triples, failures, work_queue, output_dir,
        results_summaries=results_summaries,
    )
    return format_dashboard(stats)
