"""Loogle HTTP client — type-based search over Mathlib declarations.

Loogle (loogle.lean-lang.org) is a search engine for Lean 4 / Mathlib that
supports both name-based and type-signature-based queries.  This module wraps
its JSON API and adds:
  - In-memory caching (avoid duplicate network calls within a run)
  - Rate limiting (configurable delay between calls)
  - Graceful degradation (network errors → empty results + warning)

Used by:
  - TranslatorAgent: supplement TF-IDF hints with type-precise Mathlib results
  - LoogleLibrary: dedup backend for the Librarian
"""

from __future__ import annotations

import json
import logging
import time
import urllib.error
import urllib.parse
import urllib.request
from dataclasses import dataclass, field

logger = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# Data types
# ---------------------------------------------------------------------------

@dataclass
class LoogleResult:
    """A single search result from the Loogle API."""
    name: str
    type_sig: str         # Lean 4 type signature
    module: str           # Mathlib module path (e.g. "Mathlib.Data.Nat.Basic")
    doc: str = ""         # optional docstring

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, LoogleResult):
            return NotImplemented
        return self.name == other.name

    def __hash__(self) -> int:
        return hash(self.name)


# ---------------------------------------------------------------------------
# Client
# ---------------------------------------------------------------------------

class LoogleClient:
    """HTTP client for the Loogle Mathlib search API (loogle.lean-lang.org).

    Args:
        base_url: API base URL (no trailing slash).
        timeout: HTTP request timeout in seconds.
        rate_limit: Minimum seconds between consecutive API calls.
    """

    def __init__(
        self,
        base_url: str = "https://loogle.lean-lang.org",
        timeout: float = 10.0,
        rate_limit: float = 0.5,
    ):
        self._base_url = base_url.rstrip("/")
        self._timeout = timeout
        self._rate_limit = rate_limit
        self._cache: dict[str, list[LoogleResult]] = {}
        self._last_call: float = 0.0

    # -- public API --------------------------------------------------------

    def search(self, query: str, num_results: int = 10) -> list[LoogleResult]:
        """Search Loogle.  Query can be a name fragment or a type signature.

        Examples::

            search("Nat.add_comm")                       # by name
            search("List.map")                           # partial name
            search("\\u2200 (a b : \\u2115), a + b = b + a")  # by type

        Returns at most *num_results* results (Loogle may return fewer).
        On any failure (network, timeout, API error) returns an empty list
        and logs a warning.
        """
        return self._query(query, num_results)

    def search_by_type(self, type_sig: str, num_results: int = 10) -> list[LoogleResult]:
        """Search specifically by type signature.

        Identical to :meth:`search` — Loogle auto-detects query type — but
        provided for semantic clarity.
        """
        return self._query(type_sig, num_results)

    # -- internals ---------------------------------------------------------

    def _query(self, query: str, num_results: int) -> list[LoogleResult]:
        """Execute a single Loogle query with caching and rate limiting."""
        query = query.strip()
        if not query:
            return []

        # Cache lookup
        cache_key = query
        if cache_key in self._cache:
            return self._cache[cache_key][:num_results]

        # Rate limiting
        elapsed = time.monotonic() - self._last_call
        if elapsed < self._rate_limit:
            time.sleep(self._rate_limit - elapsed)

        # Build URL
        encoded = urllib.parse.quote(query, safe="")
        url = f"{self._base_url}/json?q={encoded}"

        try:
            req = urllib.request.Request(url, headers={"User-Agent": "LeanKnowledge/0.2"})
            with urllib.request.urlopen(req, timeout=self._timeout) as resp:
                raw = resp.read().decode("utf-8")
        except (urllib.error.URLError, urllib.error.HTTPError, OSError, TimeoutError) as exc:
            logger.warning("Loogle query failed for %r: %s", query, exc)
            self._last_call = time.monotonic()
            self._cache[cache_key] = []
            return []

        self._last_call = time.monotonic()

        # Parse response
        try:
            data = json.loads(raw)
        except json.JSONDecodeError:
            logger.warning("Loogle returned invalid JSON for %r", query)
            self._cache[cache_key] = []
            return []

        # Check for API-level error
        api_error = data.get("error")
        if api_error:
            logger.info("Loogle API error for %r: %s", query, api_error)
            self._cache[cache_key] = []
            return []

        # Parse hits
        results: list[LoogleResult] = []
        for hit in data.get("hits", []):
            results.append(LoogleResult(
                name=hit.get("name", ""),
                type_sig=hit.get("type", ""),
                module=hit.get("module", ""),
                doc=hit.get("doc") or "",
            ))

        self._cache[cache_key] = results
        return results[:num_results]

    def clear_cache(self) -> None:
        """Clear the in-memory query cache."""
        self._cache.clear()
