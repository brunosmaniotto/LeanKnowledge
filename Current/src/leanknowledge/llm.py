"""Unified LLM gateway via LiteLLM.

All LLM calls in the pipeline go through this module. Model routing is
configured via environment variables with sensible defaults.

Default models:
  - LK_MODEL_FAST_A:  anthropic/claude-sonnet-4-20250514
  - LK_MODEL_FAST_B:  Goedel-Prover-V2 via local vLLM server
  - LK_MODEL_HEAVY:   anthropic/claude-sonnet-4-20250514  (Sonnet as heavy default)

For self-hosted models (vLLM, etc.), set LK_MODEL_FAST_B_API_BASE to the
server URL (e.g., http://10.128.0.3:8000/v1). The model string should use
the openai/ prefix (e.g., openai/Goedel-LM/Goedel-Prover-V2-8B).
"""

import json
import os

import litellm

# Defaults — Goedel-Prover via local vLLM as Tier 1, Sonnet as heavy
MODEL_FAST_A = os.environ.get("LK_MODEL_FAST_A", "anthropic/claude-sonnet-4-20250514")
MODEL_FAST_B = os.environ.get("LK_MODEL_FAST_B", "openai/Goedel-LM/Goedel-Prover-V2-8B")
MODEL_HEAVY = os.environ.get("LK_MODEL_HEAVY", "anthropic/claude-sonnet-4-20250514")

# Per-model API base URLs for self-hosted models
_MODEL_API_BASES: dict[str, str] = {}
_fast_b_base = os.environ.get("LK_MODEL_FAST_B_API_BASE")
if _fast_b_base:
    _MODEL_API_BASES[MODEL_FAST_B] = _fast_b_base

# Suppress LiteLLM's verbose logging by default
litellm.suppress_debug_info = True


def complete(
    model: str,
    prompt: str,
    system: str = "",
    max_tokens: int = 8192,
    temperature: float = 0.0,
) -> str:
    """Call an LLM and return the text response.

    Uses LiteLLM so any supported provider works with the same interface.
    For self-hosted models, routes to the configured api_base.
    """
    messages = []
    if system:
        messages.append({"role": "system", "content": system})
    messages.append({"role": "user", "content": prompt})

    kwargs: dict = {
        "model": model,
        "messages": messages,
        "max_tokens": max_tokens,
        "temperature": temperature,
    }

    api_base = _MODEL_API_BASES.get(model)
    if api_base:
        kwargs["api_base"] = api_base
        kwargs["api_key"] = "dummy"  # vLLM doesn't need a real key

    response = litellm.completion(**kwargs)
    return response.choices[0].message.content


def complete_json(
    model: str,
    prompt: str,
    system: str = "",
    max_tokens: int = 8192,
    temperature: float = 0.0,
) -> dict:
    """Call an LLM and parse the response as JSON."""
    text = complete(model, prompt, system=system, max_tokens=max_tokens,
                    temperature=temperature)

    # Strip markdown code fences if present
    stripped = text.strip()
    if stripped.startswith("```"):
        lines = stripped.split("\n")
        lines = [l for l in lines if not l.strip().startswith("```")]
        stripped = "\n".join(lines)

    return json.loads(stripped)
