"""ProofWiki adapter — loads NaturalProofs dataset into ExtractedItems.

The NaturalProofs dataset (Welleck et al., NeurIPS 2021) contains 19,734
theorems from ProofWiki with structured proofs.

Since ProofWiki content is already structured (statement + proof + categories),
we skip Agents 1-4 (extraction/triage/librarian) and feed directly into
Agent 5 (Proof Structurer) → Agent 6 (Translator).

Dataset JSON schema (abridged):
  {
    "dataset": {
      "theorems": [
        {
          "id": 12345,
          "label": "Compact Subspace of Hausdorff Space is Closed",
          "contents": ["Let ...", "Then ..."],
          "has_proof": true,
          "proofs": [{"contents": ["Let...", "By..."], "refs": [456, 789]}],
          "categories": ["Topology"],
          "toplevel_categories": ["Topology"]
        }
      ],
      "definitions": [...],
      "others": [...]
    }
  }
"""

import json
import re
from pathlib import Path

from .schemas import ExtractedItem, StatementType, ClaimRole


def _clean_wiki_markup(lines: list[str]) -> str:
    """Join content lines and strip light ProofWiki/MediaWiki markup."""
    text = "\n".join(lines)
    # Remove {{...}} templates but keep their text content
    text = re.sub(r"\{\{[^}]*\}\}", "", text)
    # Remove [[ ]] wiki links, keeping display text
    text = re.sub(r"\[\[(?:[^|\]]*\|)?([^\]]*)\]\]", r"\1", text)
    # Remove <ref>...</ref>
    text = re.sub(r"<ref[^>]*>.*?</ref>", "", text, flags=re.DOTALL)
    # Remove remaining HTML tags
    text = re.sub(r"<[^>]+>", "", text)
    # Collapse whitespace
    text = re.sub(r"\n{3,}", "\n\n", text)
    return text.strip()


def _classify_label(label: str) -> StatementType:
    """Infer statement type from the ProofWiki label."""
    lower = label.lower()
    if lower.startswith("definition:"):
        return StatementType.DEFINITION
    if "lemma" in lower:
        return StatementType.LEMMA
    if "corollary" in lower:
        return StatementType.COROLLARY
    if "proposition" in lower:
        return StatementType.PROPOSITION
    return StatementType.THEOREM


def _theorem_to_item(entry: dict, definitions: dict[int, str] | None = None) -> ExtractedItem:
    """Convert one NaturalProofs theorem entry to an ExtractedItem."""
    label = entry["label"]
    statement = _clean_wiki_markup(entry.get("contents", []))
    stype = _classify_label(label)

    # Extract first proof if available
    proof = None
    if entry.get("proofs"):
        proof_lines = entry["proofs"][0].get("contents", [])
        if proof_lines:
            proof = _clean_wiki_markup(proof_lines)

    # Dependencies from proof refs
    deps = []
    if entry.get("proofs"):
        for ref_id in entry["proofs"][0].get("refs", []):
            if definitions and ref_id in definitions:
                deps.append(definitions[ref_id])
            else:
                deps.append(str(ref_id))

    # Category as section
    categories = entry.get("toplevel_categories", entry.get("categories", []))
    section = categories[0] if categories else "Uncategorized"

    role = ClaimRole.DEFINITION if stype == StatementType.DEFINITION else ClaimRole.CLAIMED_RESULT

    return ExtractedItem(
        id=label,
        type=stype,
        role=role,
        statement=statement,
        proof=proof,
        dependencies=deps,
        section=section,
    )


def load_proofwiki(
    path: Path,
    *,
    with_proof_only: bool = True,
    categories: list[str] | None = None,
    max_items: int | None = None,
) -> list[ExtractedItem]:
    """Load ProofWiki theorems from NaturalProofs JSON.

    Args:
        path: path to naturalproofs_proofwiki.json
        with_proof_only: skip theorems that have no proof (default True)
        categories: filter to these top-level categories (case-insensitive)
        max_items: limit the number of items returned

    Returns:
        List of ExtractedItem objects ready for the formalization pipeline.
    """
    data = json.loads(path.read_text(encoding="utf-8"))
    ds = data["dataset"]

    # Build ID → label lookup for definitions (used in dependency refs)
    def_lookup: dict[int, str] = {}
    for d in ds.get("definitions", []):
        def_lookup[d["id"]] = d["label"]
    # Also include other theorems for cross-references
    for t in ds["theorems"]:
        def_lookup[t["id"]] = t["label"]

    # Normalize category filter
    cat_filter = None
    if categories:
        cat_filter = {c.lower() for c in categories}

    items = []
    for entry in ds["theorems"]:
        if with_proof_only and not entry.get("proofs"):
            continue

        if cat_filter:
            entry_cats = {c.lower() for c in entry.get("toplevel_categories", [])}
            if not entry_cats & cat_filter:
                continue

        items.append(_theorem_to_item(entry, def_lookup))

        if max_items and len(items) >= max_items:
            break

    return items


def dataset_stats(path: Path) -> dict:
    """Quick stats about the ProofWiki dataset."""
    data = json.loads(path.read_text(encoding="utf-8"))
    ds = data["dataset"]

    from collections import Counter
    cats = Counter()
    for t in ds["theorems"]:
        for c in t.get("toplevel_categories", []):
            cats[c] += 1

    n_theorems = len(ds["theorems"])
    n_with_proof = sum(1 for t in ds["theorems"] if t.get("proofs"))

    return {
        "theorems": n_theorems,
        "with_proof": n_with_proof,
        "definitions": len(ds.get("definitions", [])),
        "others": len(ds.get("others", [])),
        "top_categories": cats.most_common(30),
    }
