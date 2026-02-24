"""Loogle client — type-based search over Mathlib via loogle.lean-lang.org.

Loogle is a search engine for Lean 4 / Mathlib that supports:
- Name search: "IsCompact" → declarations containing that name
- Type pattern search: "_ → IsCompact _ → ∃ _" → type-matching declarations
- Keyword search: "compact continuous maximum" → relevant declarations

JSON API: GET https://loogle.lean-lang.org/json?q=QUERY

Used by the Librarian as Layer 3 (between BM25 and Claude fallback).
"""

import json
import urllib.error
import urllib.parse
import urllib.request
from dataclasses import dataclass


LOOGLE_API = "https://loogle.lean-lang.org/json"
TIMEOUT_SECONDS = 10
MAX_RESULTS = 10


@dataclass
class LoogleHit:
    """A single Loogle search result."""
    name: str           # e.g. "IsCompact.exists_isMaxOn"
    module: str         # e.g. "Mathlib.Topology.Order.Basic"
    type_sig: str       # Lean type signature
    doc: str            # docstring / description


def search(query: str, max_results: int = MAX_RESULTS) -> list[LoogleHit]:
    """Search Loogle for Mathlib declarations matching the query.

    Args:
        query: Search string — can be a name, type pattern, or keywords.
        max_results: Maximum number of results to return.

    Returns:
        List of LoogleHit objects, or empty list on failure.
    """
    url = f"{LOOGLE_API}?{urllib.parse.urlencode({'q': query})}"

    try:
        req = urllib.request.Request(url, headers={"Accept": "application/json"})
        with urllib.request.urlopen(req, timeout=TIMEOUT_SECONDS) as resp:
            data = json.loads(resp.read().decode("utf-8"))
    except (urllib.error.URLError, urllib.error.HTTPError, TimeoutError, OSError) as e:
        print(f"  [loogle] Request failed: {e}")
        return []
    except json.JSONDecodeError:
        print("  [loogle] Invalid JSON response")
        return []

    hits = data.get("hits", [])
    results = []
    for hit in hits[:max_results]:
        results.append(LoogleHit(
            name=hit.get("name", ""),
            module=hit.get("module", ""),
            type_sig=hit.get("type", ""),
            doc=hit.get("doc", ""),
        ))
    return results


def search_by_name(name: str, max_results: int = MAX_RESULTS) -> list[LoogleHit]:
    """Search Loogle by declaration name."""
    return search(name, max_results)


def search_by_type(type_pattern: str, max_results: int = MAX_RESULTS) -> list[LoogleHit]:
    """Search Loogle by type signature pattern.

    Examples:
        "_ → IsCompact _ → ContinuousOn _ _ → ∃ _"
        "Finset _ → _ → _"
        "List.map"
    """
    return search(type_pattern, max_results)


def module_to_import(module: str) -> str:
    """Convert a Loogle module path to a Lean import statement.

    'Mathlib.Topology.Order.Basic' → 'Mathlib.Topology.Order.Basic'
    (identity for Mathlib modules, but normalizes edge cases)
    """
    return module.strip()
