#!/usr/bin/env python3
"""Build a Mathlib declaration index for retrieval-augmented translation.

Two approaches for collecting declarations:

  Option A (offline): Parse Lean/Mathlib source files for theorem/lemma/def
    declarations and extract names + type signatures. Works without a running
    Lean server — just needs the Mathlib source tree.

  Option B (live): Query the Loogle API (https://loogle.lean-lang.org/) for
    declarations matching seed queries. Good for targeted retrieval but
    rate-limited.

Usage:
    # Build from a local Mathlib source tree
    python build_mathlib_index.py --mathlib-src ~/lean-project/.lake/packages/mathlib/Mathlib \\
        --output data/mathlib_index.json

    # Build from an existing declarations JSON
    python build_mathlib_index.py --declarations data/mathlib_decls.json \\
        --output data/mathlib_index.json

    # Add Rosetta Stone entries to an existing index
    python build_mathlib_index.py --index data/mathlib_index.json \\
        --rosetta outputs/rosetta_stone.jsonl \\
        --output data/mathlib_index.json

    # Query Loogle for specific topics (supplements the local index)
    python build_mathlib_index.py --loogle "Nat.Prime" "Finset.sum" \\
        --output data/mathlib_index.json
"""

import argparse
import json
import re
import sys
from pathlib import Path

# Add the project source to the path
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent
sys.path.insert(0, str(PROJECT_ROOT / "src"))

from leanknowledge.mathlib_index import MathlibIndex


# ---------------------------------------------------------------------------
# Option A: Parse Lean source files
# ---------------------------------------------------------------------------

# Regex patterns for Lean 4 declarations
_DECL_RE = re.compile(
    r'^(?:(?:protected|private|noncomputable|nonrec|partial)\s+)*'
    r'(?:theorem|lemma|def|instance|abbrev)\s+'
    r'(\S+)'           # declaration name
    r'(.*)',            # rest of line (binders + type signature)
    re.MULTILINE,
)

# Docstring pattern: /-- ... -/ immediately before a declaration
_DOC_RE = re.compile(r'/--\s*(.*?)\s*-/', re.DOTALL)


def _extract_signature(rest_of_line: str) -> str:
    """Extract the type signature from the rest of a declaration line.

    Given text like `(n m : Nat) : n + m = m + n := by`, finds the
    last top-level `:` (not inside parens/brackets/braces) and returns
    everything after it up to `:=` or `where` or end-of-line.

    Returns the type signature, or the full rest_of_line if no
    top-level `:` is found.
    """
    if not rest_of_line:
        return ""

    # Find the last top-level colon
    depth = 0
    last_colon = -1
    for i, ch in enumerate(rest_of_line):
        if ch in '([{':
            depth += 1
        elif ch in ')]}':
            depth = max(0, depth - 1)
        elif ch == ':' and depth == 0:
            # Check it's not `:=`
            if i + 1 < len(rest_of_line) and rest_of_line[i + 1] == '=':
                continue
            last_colon = i

    if last_colon >= 0:
        sig = rest_of_line[last_colon + 1:].strip()
        # Remove trailing `:= ...`
        assign = sig.find(':=')
        if assign >= 0:
            sig = sig[:assign].strip()
        return sig
    else:
        return ""


def parse_lean_file(path: Path) -> list[dict]:
    """Extract declarations from a single Lean file.

    Returns a list of dicts: {name, signature, docstring}.
    This is a best-effort parser — it won't catch everything, but it
    reliably extracts the majority of top-level declarations.
    """
    try:
        text = path.read_text(encoding="utf-8")
    except (OSError, UnicodeDecodeError):
        return []

    # Compute the module path from the file path
    # e.g., Mathlib/Data/Nat/Prime/Basic.lean → Mathlib.Data.Nat.Prime.Basic
    parts = path.parts
    # Find "Mathlib" in the path to determine the module root
    try:
        mathlib_idx = parts.index("Mathlib")
        module_prefix = ".".join(parts[mathlib_idx:]).replace(".lean", "")
    except ValueError:
        module_prefix = path.stem

    declarations = []

    # Find all docstrings and their positions
    doc_positions: list[tuple[int, str]] = []
    for m in _DOC_RE.finditer(text):
        doc_positions.append((m.end(), m.group(1).strip()))

    # Find all declarations
    for m in _DECL_RE.finditer(text):
        name = m.group(1)
        rest_of_line = (m.group(2) or "").strip()

        # Skip internal/compiler-generated names and non-identifier names
        # (e.g., anonymous instances where `instance : Foo` captures `:` as name)
        if name.startswith("_") or "._" in name:
            continue
        if not re.match(r'^[a-zA-Z]', name):
            continue

        # Find the closest preceding docstring (within 50 chars — accounting for whitespace)
        docstring = ""
        decl_start = m.start()
        for doc_end, doc_text in reversed(doc_positions):
            gap = decl_start - doc_end
            if 0 <= gap <= 50:  # docstring must be close to the declaration
                docstring = doc_text
                break

        # Extract type signature from the rest of the line.
        # Find the last top-level `:` (not inside parens/brackets/braces)
        # that separates binders from the return type.
        sig_fragment = _extract_signature(rest_of_line)

        # Clean up the signature
        if sig_fragment:
            # Remove trailing `:=` or `where`
            sig_fragment = re.sub(r'\s*:=\s*$', '', sig_fragment)
            sig_fragment = re.sub(r'\s+where\s*$', '', sig_fragment)
            sig_fragment = sig_fragment.strip()

        # Qualify the name if it doesn't already have a namespace
        if "." not in name:
            # Try to infer namespace from the file's `namespace` blocks
            # (simplified — just use the module path)
            pass  # keep the short name; it's still useful for search

        declarations.append({
            "name": name,
            "signature": sig_fragment,
            "docstring": docstring[:300],  # cap docstring length
            "source": "mathlib",
        })

    return declarations


def scan_mathlib_tree(mathlib_dir: Path, progress: bool = True) -> list[dict]:
    """Recursively scan a Mathlib source tree for declarations.

    Args:
        mathlib_dir: Root of the Mathlib source (the directory containing
            Mathlib/ subdirectories like Data/, Topology/, etc.)
        progress: Print progress updates.

    Returns:
        List of declaration dicts.
    """
    lean_files = sorted(mathlib_dir.rglob("*.lean"))
    total = len(lean_files)
    if progress:
        print(f"Scanning {total} Lean files in {mathlib_dir}...")

    all_decls = []
    for i, path in enumerate(lean_files):
        if progress and (i + 1) % 500 == 0:
            print(f"  {i + 1}/{total} files scanned, {len(all_decls)} declarations found...")
        decls = parse_lean_file(path)
        all_decls.extend(decls)

    if progress:
        print(f"  Done: {len(all_decls)} declarations from {total} files.")

    return all_decls


# ---------------------------------------------------------------------------
# Option B: Loogle API
# ---------------------------------------------------------------------------

def query_loogle(query: str, num_results: int = 20) -> list[dict]:
    """Query the Loogle API for Mathlib declarations.

    Loogle (https://loogle.lean-lang.org/) is a type-based search engine
    for Lean 4 / Mathlib. It accepts queries like:
        "Nat.Prime"         → declarations containing Nat.Prime
        "∀ n : ℕ, _ + _"   → type-based search

    Returns a list of declaration dicts.
    """
    import urllib.request
    import urllib.parse

    url = f"https://loogle.lean-lang.org/api?q={urllib.parse.quote(query)}"
    try:
        with urllib.request.urlopen(url, timeout=15) as resp:
            data = json.loads(resp.read().decode())
    except Exception as e:
        print(f"  Loogle query failed for '{query}': {e}")
        return []

    decls = []
    for hit in data.get("hits", [])[:num_results]:
        name = hit.get("name", "")
        sig = hit.get("type", "")
        doc = hit.get("doc", "")
        if name:
            decls.append({
                "name": name,
                "signature": sig,
                "docstring": doc[:300],
                "source": "mathlib",
            })

    return decls


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description="Build a Mathlib declaration index for RAG-augmented translation."
    )
    parser.add_argument(
        "--mathlib-src", type=Path, default=None,
        help="Path to Mathlib source directory (e.g., .lake/packages/mathlib/Mathlib)",
    )
    parser.add_argument(
        "--declarations", type=Path, default=None,
        help="Path to a pre-existing declarations JSON file",
    )
    parser.add_argument(
        "--index", type=Path, default=None,
        help="Path to an existing index to update (instead of building from scratch)",
    )
    parser.add_argument(
        "--rosetta", type=Path, default=None,
        help="Path to rosetta_stone.jsonl to add to the index",
    )
    parser.add_argument(
        "--loogle", nargs="*", default=None,
        help="Loogle API queries to supplement the index (e.g., 'Nat.Prime' 'Finset.sum')",
    )
    parser.add_argument(
        "--output", type=Path, required=True,
        help="Path to save the index JSON file",
    )
    parser.add_argument(
        "--no-embeddings", action="store_true",
        help="Skip embedding computation (TF-IDF only)",
    )

    args = parser.parse_args()

    # Start with existing index or create new
    index = MathlibIndex(use_embeddings=not args.no_embeddings)
    if args.index and args.index.exists():
        print(f"Loading existing index: {args.index}")
        index.load(args.index)
        print(f"  Loaded {index.size} declarations")

    # Add declarations from Mathlib source tree
    if args.mathlib_src:
        decls = scan_mathlib_tree(args.mathlib_src)
        if decls:
            index.add_declarations(decls)
            print(f"  Index now has {index.size} declarations")

    # Add declarations from a JSON file
    if args.declarations:
        print(f"Loading declarations from {args.declarations}...")
        data = json.loads(args.declarations.read_text(encoding="utf-8"))
        # Support both flat list and nested {"declarations": [...]} format
        if isinstance(data, dict):
            data = data.get("declarations", [])
        index.add_declarations(data)
        print(f"  Index now has {index.size} declarations")

    # Add Loogle results
    if args.loogle:
        for query in args.loogle:
            print(f"Querying Loogle: {query}...")
            decls = query_loogle(query)
            if decls:
                print(f"  Got {len(decls)} results")
                index.add_declarations(decls)

        print(f"  Index now has {index.size} declarations")

    # Add Rosetta Stone entries
    if args.rosetta:
        print(f"Loading Rosetta Stone entries from {args.rosetta}...")
        index.load_rosetta(args.rosetta)
        print(f"  Index now has {index.size} declarations")

    # Save
    index.save(args.output)
    print(f"\nIndex saved to {args.output} ({index.size} declarations)")


if __name__ == "__main__":
    main()
