"""Unified LLM gateway via LiteLLM.

All LLM calls in the pipeline go through this module. Model routing is
configured via environment variables with sensible defaults.

Default models:
  - LK_MODEL_FAST_A:  anthropic/claude-sonnet-4-20250514
  - LK_MODEL_FAST_B:  deepseek/deepseek-reasoner  (DeepThink)
  - LK_MODEL_HEAVY:   anthropic/claude-opus-4-20250115
"""

import json
import os

import litellm

# Defaults
MODEL_FAST_A = os.environ.get("LK_MODEL_FAST_A", "anthropic/claude-sonnet-4-20250514")
MODEL_FAST_B = os.environ.get("LK_MODEL_FAST_B", "deepseek/deepseek-reasoner")
MODEL_HEAVY = os.environ.get("LK_MODEL_HEAVY", "anthropic/claude-opus-4-20250115")

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
    """
    messages = []
    if system:
        messages.append({"role": "system", "content": system})
    messages.append({"role": "user", "content": prompt})

    response = litellm.completion(
        model=model,
        messages=messages,
        max_tokens=max_tokens,
        temperature=temperature,
    )
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
