"""Agent 2: Claim Extraction — reads mathematical text and extracts structured claims.

Ensemble approach with escalation:
  1. Run Sonnet and DeepThink in parallel on the same text
  2. Compare outputs programmatically
  3. If they agree → high confidence, return merged result
  4. If they disagree → escalate to Opus as arbiter

Why mix models? Same-family models share blind spots (correlated failures).
Different architectures catch different things, making disagreement a
more meaningful signal than any heuristic quality check.
"""

import concurrent.futures
from difflib import SequenceMatcher
from pathlib import Path

from ..schemas import ExtractionResult, ExtractedItem
from ..llm import complete_json, MODEL_FAST_A, MODEL_FAST_B, MODEL_HEAVY

PROMPT_PATH = Path(__file__).resolve().parents[3] / "prompts" / "extraction_agent.md"

# ---------------------------------------------------------------------------
# Disagreement thresholds
# ---------------------------------------------------------------------------

# If one model finds >40% more items than the other, that's a disagreement
COUNT_DIVERGENCE_THRESHOLD = 0.4

# Minimum fraction of items that must have a match in the other extraction
OVERLAP_THRESHOLD = 0.6


# ---------------------------------------------------------------------------
# Disagreement detection (programmatic, no LLM)
# ---------------------------------------------------------------------------

def _normalize(s: str) -> str:
    """Lowercase, strip whitespace for fuzzy comparison."""
    return " ".join(s.lower().split())


def _fuzzy_match(a: str, b: str) -> float:
    """Similarity ratio between two strings (0-1)."""
    return SequenceMatcher(None, _normalize(a), _normalize(b)).ratio()


def _find_best_match(item: ExtractedItem, candidates: list[ExtractedItem]) -> float:
    """Find the best fuzzy match score for an item in a list of candidates."""
    if not candidates:
        return 0.0
    # Match on statement (the core content)
    return max(_fuzzy_match(item.statement, c.statement) for c in candidates)


def assess_agreement(
    result_a: ExtractionResult,
    result_b: ExtractionResult,
) -> dict:
    """Compare two extraction results and decide if they agree.

    Returns:
        dict with keys:
            - agree: bool
            - reason: str | None — explanation if they disagree
            - count_a, count_b: int
            - overlap_a_in_b, overlap_b_in_a: float (0-1)
            - details: str — human-readable summary
    """
    items_a = result_a.items
    items_b = result_b.items
    count_a, count_b = len(items_a), len(items_b)

    # Count divergence
    if count_a == 0 and count_b == 0:
        return {"agree": True, "reason": None, "count_a": 0, "count_b": 0,
                "overlap_a_in_b": 1.0, "overlap_b_in_a": 1.0,
                "details": "Both extractions empty"}

    max_count = max(count_a, count_b)
    min_count = min(count_a, count_b)
    count_ratio = (max_count - min_count) / max_count if max_count > 0 else 0

    # Overlap: what fraction of A's items appear in B (and vice versa)?
    match_threshold = 0.6  # two statements are "the same" if similarity > 0.6
    if items_a and items_b:
        matched_a = sum(1 for item in items_a
                        if _find_best_match(item, items_b) > match_threshold)
        matched_b = sum(1 for item in items_b
                        if _find_best_match(item, items_a) > match_threshold)
        overlap_a_in_b = matched_a / count_a
        overlap_b_in_a = matched_b / count_b
    else:
        overlap_a_in_b = 0.0
        overlap_b_in_a = 0.0

    # Decision
    reasons = []
    if count_ratio > COUNT_DIVERGENCE_THRESHOLD:
        reasons.append(f"count_divergence ({count_a} vs {count_b})")
    if overlap_a_in_b < OVERLAP_THRESHOLD:
        reasons.append(f"low_overlap_a_in_b ({overlap_a_in_b:.0%})")
    if overlap_b_in_a < OVERLAP_THRESHOLD:
        reasons.append(f"low_overlap_b_in_a ({overlap_b_in_a:.0%})")

    agree = len(reasons) == 0
    details = (f"Model A: {count_a} items, Model B: {count_b} items. "
               f"Overlap: A in B = {overlap_a_in_b:.0%}, B in A = {overlap_b_in_a:.0%}")

    return {
        "agree": agree,
        "reason": "; ".join(reasons) if reasons else None,
        "count_a": count_a,
        "count_b": count_b,
        "overlap_a_in_b": overlap_a_in_b,
        "overlap_b_in_a": overlap_b_in_a,
        "details": details,
    }


# ---------------------------------------------------------------------------
# Merging (when models agree)
# ---------------------------------------------------------------------------

def _merge_results(
    result_a: ExtractionResult,
    result_b: ExtractionResult,
    source_label: str,
) -> ExtractionResult:
    """Merge two agreeing extractions, preferring the more complete version
    and adding unique items from the other."""
    # Start with whichever found more items
    if len(result_a.items) >= len(result_b.items):
        primary, secondary = result_a, result_b
    else:
        primary, secondary = result_b, result_a

    merged_items = list(primary.items)
    primary_ids = {_normalize(item.id) for item in primary.items}
    statement_threshold = 0.85  # high bar — short math statements share vocabulary

    # Add items from secondary that aren't in primary
    for item in secondary.items:
        # Skip if same ID already present
        if _normalize(item.id) in primary_ids:
            continue
        # Skip if statement is near-identical to one already merged
        best_score = _find_best_match(item, merged_items)
        if best_score > statement_threshold:
            continue
        merged_items.append(item)

    return ExtractionResult(source=source_label, items=merged_items)


# ---------------------------------------------------------------------------
# LLM calls
# ---------------------------------------------------------------------------

def _build_prompt(text: str, source_label: str) -> str:
    return (
        f"Source: {source_label}\n\n"
        f"--- BEGIN TEXT ---\n{text}\n--- END TEXT ---\n\n"
        f"Extract all formal mathematical items from the text above.\n\n"
        f"Respond with ONLY valid JSON matching this structure:\n"
        f'{{"source": "...", "items": [...]}}\n'
        f"Each item must have: id, type, role, statement, proof (or null), "
        f"proof_sketch (or null), dependencies (list), section, labeled (bool), "
        f"context (or null), notation_in_scope (dict).\n\n"
        f"Valid types: definition, axiom, proposition, theorem, lemma, corollary, "
        f"example, remark, claim, invoked_dependency, implicit_assumption.\n"
        f"Valid roles: definition, claimed_result, invoked_dependency, implicit_assumption."
    )


def _call_model(model: str, text: str, source_label: str, system: str) -> ExtractionResult:
    """Call a single model and parse the result."""
    prompt = _build_prompt(text, source_label)
    data = complete_json(model, prompt, system=system)
    return _validate_result(data, source_label)


def _validate_result(data: dict, source_label: str) -> ExtractionResult:
    if isinstance(data, dict):
        if "items" not in data:
            data = {"source": source_label, "items": data if isinstance(data, list) else [data]}
        if "source" not in data:
            data["source"] = source_label
        return ExtractionResult.model_validate(data)
    return ExtractionResult(source=source_label, items=[])


def _build_arbiter_prompt(
    text: str,
    result_a: ExtractionResult,
    result_b: ExtractionResult,
    agreement: dict,
    source_label: str,
) -> str:
    """Build prompt for Opus arbiter — sees both extractions + source text."""
    import json as _json

    items_a_json = _json.dumps([item.model_dump() for item in result_a.items], indent=2)
    items_b_json = _json.dumps([item.model_dump() for item in result_b.items], indent=2)

    return (
        f"Source: {source_label}\n\n"
        f"Two independent models extracted mathematical claims from the same text. "
        f"They disagreed: {agreement['reason']}\n"
        f"{agreement['details']}\n\n"
        f"--- MODEL A EXTRACTION ({agreement['count_a']} items) ---\n{items_a_json}\n\n"
        f"--- MODEL B EXTRACTION ({agreement['count_b']} items) ---\n{items_b_json}\n\n"
        f"--- ORIGINAL TEXT ---\n{text}\n--- END TEXT ---\n\n"
        f"Your job: produce the DEFINITIVE extraction. Review both models' outputs "
        f"against the original text. Include every genuine mathematical claim. "
        f"Resolve disagreements by checking the source text.\n\n"
        f"Respond with ONLY valid JSON matching this structure:\n"
        f'{{"source": "...", "items": [...]}}\n'
        f"Each item must have: id, type, role, statement, proof (or null), "
        f"proof_sketch (or null), dependencies (list), section, labeled (bool), "
        f"context (or null), notation_in_scope (dict).\n\n"
        f"Valid types: definition, axiom, proposition, theorem, lemma, corollary, "
        f"example, remark, claim, invoked_dependency, implicit_assumption.\n"
        f"Valid roles: definition, claimed_result, invoked_dependency, implicit_assumption."
    )


# ---------------------------------------------------------------------------
# Main agent
# ---------------------------------------------------------------------------

class ClaimExtractionAgent:
    """Agent 2: Extract mathematical claims from text.

    Runs two models in parallel (Sonnet + DeepThink), compares results,
    and escalates to Opus if they disagree.
    """

    def __init__(
        self,
        model_a: str = MODEL_FAST_A,
        model_b: str = MODEL_FAST_B,
        model_arbiter: str = MODEL_HEAVY,
    ):
        self.model_a = model_a
        self.model_b = model_b
        self.model_arbiter = model_arbiter

    def extract(
        self,
        text: str,
        source_label: str = "",
        force_arbiter: bool = False,
    ) -> ExtractionResult:
        """Extract mathematical claims from text using ensemble + escalation.

        Args:
            text: mathematical text (from Agent 1)
            source_label: human-readable source name
            force_arbiter: skip ensemble, go straight to Opus
        """
        system = PROMPT_PATH.read_text() if PROMPT_PATH.exists() else ""

        if force_arbiter:
            print(f"  [Agent 2] Forced arbiter mode (Opus)")
            return self._run_arbiter(text, None, None, None, source_label, system)

        # Run both models in parallel
        print(f"  [Agent 2] Running ensemble: {self.model_a} + {self.model_b}")
        with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
            future_a = pool.submit(_call_model, self.model_a, text, source_label, system)
            future_b = pool.submit(_call_model, self.model_b, text, source_label, system)
            result_a = future_a.result()
            result_b = future_b.result()

        print(f"    Model A ({self.model_a}): {len(result_a.items)} items")
        print(f"    Model B ({self.model_b}): {len(result_b.items)} items")

        # Compare
        agreement = assess_agreement(result_a, result_b)
        print(f"    {agreement['details']}")

        if agreement["agree"]:
            print(f"  [Agent 2] Models agree — merging results")
            merged = _merge_results(result_a, result_b, source_label)
            print(f"    Merged: {len(merged.items)} items")
            return merged

        # Escalate to arbiter
        print(f"  [Agent 2] Models disagree ({agreement['reason']}). "
              f"Escalating to arbiter ({self.model_arbiter})")
        return self._run_arbiter(text, result_a, result_b, agreement, source_label, system)

    def _run_arbiter(
        self,
        text: str,
        result_a: ExtractionResult | None,
        result_b: ExtractionResult | None,
        agreement: dict | None,
        source_label: str,
        system: str,
    ) -> ExtractionResult:
        """Run Opus as arbiter with both extractions + source text."""
        if result_a is not None and result_b is not None and agreement is not None:
            prompt = _build_arbiter_prompt(text, result_a, result_b, agreement, source_label)
        else:
            # force_arbiter mode — just extract directly
            prompt = _build_prompt(text, source_label)

        data = complete_json(self.model_arbiter, prompt, system=system, max_tokens=16384)
        result = _validate_result(data, source_label)
        print(f"    Arbiter: {len(result.items)} items")
        return result
