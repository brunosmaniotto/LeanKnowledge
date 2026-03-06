"""Unified LLM gateway using LiteLLM.

Provides a single `call_llm()` function that routes to any supported provider:
- Anthropic (Claude): "claude-sonnet-4-6", "claude-haiku-4-5-20251001"
- OpenAI: "gpt-4o", "gpt-4o-mini"
- DeepSeek: "deepseek/deepseek-prover-v2"
- Local vLLM: "openai/my-model" (with api_base override)

Usage:
    from leanknowledge.llm_gateway import call_llm
    result = call_llm("Prove this theorem", system="You are a proof assistant", model="claude-sonnet-4-6")
"""

import json
import logging
import os
import re
from pydantic import BaseModel

try:
    import litellm
    litellm.drop_params = True  # Don't error on unsupported params
    HAS_LITELLM = True
except ImportError:
    HAS_LITELLM = False

from .claude_client import usage_tracker, _CallRecord

log = logging.getLogger(__name__)

# Model aliases for convenience
MODEL_ALIASES = {
    "sonnet": "claude-sonnet-4-6",
    "haiku": "claude-haiku-4-5-20251001",
    "opus": "claude-opus-4-6",
    "deepseek": "deepseek/deepseek-prover-v2-7b",
    "deep-think": "deepseek/deepseek-reasoner",
    "gpt4o": "openai/gpt-4o",
}

DEFAULT_MODEL = "claude-sonnet-4-6"


def call_llm(
    prompt: str,
    system: str = "",
    schema: type[BaseModel] | None = None,
    model: str | None = None,
    caller: str = "",
    api_base: str | None = None,
    temperature: float | None = None,
    max_tokens: int = 4096,
) -> str | dict:
    """Call any LLM provider through LiteLLM.

    Args:
        prompt: User message.
        system: System prompt.
        schema: If provided, request JSON conforming to this Pydantic model.
        model: Model name (supports aliases). Defaults to claude-sonnet-4-6.
        caller: Label for usage tracking.
        api_base: Optional API base URL (for local vLLM).
        temperature: Optional sampling temperature.
        max_tokens: Max output tokens.

    Returns:
        Raw text response, or parsed dict if schema is provided.
    """
    if not HAS_LITELLM:
        raise ImportError("litellm is required. Install with: uv add litellm")

    # Unset CLAUDECODE to prevent interference in Claude Code sessions
    os.environ.pop("CLAUDECODE", None)

    # Resolve aliases
    resolved_model = MODEL_ALIASES.get(model or "", model or DEFAULT_MODEL)

    messages = []
    if system:
        messages.append({"role": "system", "content": system})
    messages.append({"role": "user", "content": prompt})

    kwargs = {
        "model": resolved_model,
        "messages": messages,
        "max_tokens": max_tokens,
    }

    if temperature is not None:
        kwargs["temperature"] = temperature

    if api_base:
        kwargs["api_base"] = api_base

    if schema:
        # Request JSON response
        kwargs["response_format"] = {"type": "json_object"}
        # Add schema hint to prompt
        schema_json = json.dumps(schema.model_json_schema(), indent=2)
        messages[-1]["content"] += (
            "\n\nRespond with JSON matching this schema:\n"
            f"```json\n{schema_json}\n```"
        )

    try:
        response = litellm.completion(**kwargs)
    except Exception as e:
        raise RuntimeError(f"LLM call failed ({resolved_model}): {e}")

    text = response.choices[0].message.content or ""

    # Track usage
    usage = response.usage
    if usage:
        rec = _CallRecord(
            caller=caller,
            model=resolved_model,
            input_tokens=usage.prompt_tokens or 0,
            output_tokens=usage.completion_tokens or 0,
        )
        usage_tracker.record(rec)
        log.debug("call_llm [%s] model=%s in=%d out=%d", caller, resolved_model, rec.input_tokens, rec.output_tokens)

    if schema is None:
        return text

    # Parse JSON
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        return _extract_json(text)


def _extract_json(text: str) -> dict:
    """Extract JSON from text that may contain markdown fences."""
    match = re.search(r"```(?:json)?\s*\n?(.*?)\n?\s*```", text, re.DOTALL)
    if match:
        try:
            return json.loads(match.group(1))
        except json.JSONDecodeError:
            pass

    for start_char, end_char in [("{", "}"), ("[", "]")]:
        start = text.find(start_char)
        if start != -1:
            depth = 0
            for i, c in enumerate(text[start:], start):
                if c == start_char:
                    depth += 1
                elif c == end_char:
                    depth -= 1
                    if depth == 0:
                        try:
                            return json.loads(text[start:i + 1])
                        except json.JSONDecodeError:
                            break

    raise ValueError(f"Could not extract JSON from response:\n{text[:500]}")
