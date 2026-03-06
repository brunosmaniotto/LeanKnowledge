"""DeepSeek-Prover-V2 API client.

Uses DeepSeek's OpenAI-compatible API endpoint for theorem proving.
Designed as a drop-in alternative to call_claude() for the Resolver and Proof agents.

Configuration:
  - DEEPSEEK_API_KEY env var or .secrets/deepseek.key file
  - DEEPSEEK_ENDPOINT env var for custom endpoint (e.g., local vLLM server)
"""

import json
import os
from pathlib import Path

from pydantic import BaseModel

SECRETS_PATH = Path(__file__).resolve().parents[2] / ".secrets" / "deepseek.key"
DEFAULT_ENDPOINT = "https://api.deepseek.com"
DEFAULT_MODEL = "deepseek-prover-v2"


def _get_api_key() -> str:
    """Load DeepSeek API key from env or secrets file."""
    key = os.environ.get("DEEPSEEK_API_KEY", "")
    if key:
        return key

    if SECRETS_PATH.exists():
        key = SECRETS_PATH.read_text(encoding="utf-8").strip()
        if key:
            return key

    raise RuntimeError(
        "DeepSeek API key not found. Set DEEPSEEK_API_KEY env var "
        f"or create {SECRETS_PATH}"
    )


def _get_endpoint() -> str:
    """Get the API endpoint (supports local vLLM override)."""
    return os.environ.get("DEEPSEEK_ENDPOINT", DEFAULT_ENDPOINT)


def call_deepseek(
    prompt: str,
    system: str = "",
    schema: type[BaseModel] | None = None,
    model: str = DEFAULT_MODEL,
    caller: str = "",  # Accepted for call_claude() compatibility, not used
) -> str | dict:
    """Call DeepSeek API. Same interface as call_claude() for drop-in swap."""
    if os.environ.get("LK_USE_GATEWAY", "").lower() in ("1", "true", "yes"):
        from .llm_gateway import call_llm
        return call_llm(prompt, system=system, schema=schema, model="deepseek", caller=caller)

    from openai import OpenAI

    client = OpenAI(
        api_key=_get_api_key(),
        base_url=f"{_get_endpoint()}/v1",
    )

    messages = []
    if system:
        messages.append({"role": "system", "content": system})

    user_content = prompt
    if schema:
        schema_json = json.dumps(schema.model_json_schema(), indent=2)
        user_content += (
            f"\n\nRespond with ONLY valid JSON conforming to this schema "
            f"(no markdown, no explanation):\n```json\n{schema_json}\n```"
        )

    messages.append({"role": "user", "content": user_content})

    response = client.chat.completions.create(
        model=model,
        messages=messages,
        temperature=0.0,
        max_tokens=4096,
    )

    text = response.choices[0].message.content or ""

    if schema is None:
        return text

    return _extract_json(text)


def _extract_json(text: str) -> dict:
    """Extract JSON from response (same logic as claude_client)."""
    import re

    # Direct parse
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        pass

    # From markdown fences
    match = re.search(r"```(?:json)?\s*\n?(.*?)\n?\s*```", text, re.DOTALL)
    if match:
        try:
            return json.loads(match.group(1))
        except json.JSONDecodeError:
            pass

    # First { ... } or [ ... ] block
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

    raise ValueError(f"Could not extract valid JSON from DeepSeek response:\n{text[:500]}")
