"""Thin wrapper around Anthropic SDK for structured LLM calls."""

import json
import logging
import os
import time
import re
import uuid
from dataclasses import dataclass, field
from pydantic import BaseModel

try:
    from anthropic import Anthropic, RateLimitError, APIError
except ImportError:
    # Fallback/mocking support or nice error if dependency missing
    Anthropic = None

DEFAULT_MODEL = "claude-sonnet-4-6"

log = logging.getLogger(__name__)


def _use_gateway() -> bool:
    """Check if gateway mode is enabled (evaluated at call time, not import time)."""
    return os.environ.get("LK_USE_GATEWAY", "").lower() in ("1", "true", "yes")


# ---------------------------------------------------------------------------
# Usage tracking
# ---------------------------------------------------------------------------

@dataclass
class _CallRecord:
    """Token usage from a single API call."""
    caller: str
    model: str
    input_tokens: int = 0
    output_tokens: int = 0
    cache_creation_input_tokens: int = 0
    cache_read_input_tokens: int = 0


@dataclass
class UsageTracker:
    """Accumulates token usage across multiple call_claude() invocations.

    Access the singleton via ``usage_tracker``.  Call ``reset()`` at the
    start of a pipeline run, then ``summary()`` or ``cost()`` at the end.
    """
    calls: list[_CallRecord] = field(default_factory=list)

    def record(self, rec: _CallRecord) -> None:
        self.calls.append(rec)

    def reset(self) -> None:
        self.calls.clear()

    def totals(self) -> dict[str, int]:
        t: dict[str, int] = {
            "calls": len(self.calls),
            "input_tokens": 0,
            "output_tokens": 0,
            "cache_creation_input_tokens": 0,
            "cache_read_input_tokens": 0,
        }
        for c in self.calls:
            t["input_tokens"] += c.input_tokens
            t["output_tokens"] += c.output_tokens
            t["cache_creation_input_tokens"] += c.cache_creation_input_tokens
            t["cache_read_input_tokens"] += c.cache_read_input_tokens
        return t

    def cost(self, model: str | None = None) -> float:
        """Estimated USD cost using Anthropic published pricing.

        Pricing (per 1M tokens):
          Sonnet 4:  input $3, output $15, cache-write $3.75, cache-read $0.30
          Haiku 4.5: input $0.80, output $4, cache-write $1, cache-read $0.08
        """
        t = self.totals()
        # Use the model from the most recent call, or fall back to default
        m = model or (self.calls[-1].model if self.calls else DEFAULT_MODEL)
        if "haiku" in m:
            inp, out, cw, cr = 0.80, 4.0, 1.0, 0.08
        else:
            inp, out, cw, cr = 3.0, 15.0, 3.75, 0.30
        return (
            t["input_tokens"] * inp
            + t["output_tokens"] * out
            + t["cache_creation_input_tokens"] * cw
            + t["cache_read_input_tokens"] * cr
        ) / 1_000_000

    def summary(self) -> str:
        t = self.totals()
        c = self.cost()
        cache_hits = sum(1 for r in self.calls if r.cache_read_input_tokens > 0)
        return (
            f"{t['calls']} API calls | "
            f"input: {t['input_tokens']:,} tok | "
            f"output: {t['output_tokens']:,} tok | "
            f"cache hits: {cache_hits}/{t['calls']} | "
            f"est. cost: ${c:.4f}"
        )


# Module-level singleton
usage_tracker = UsageTracker()


def submit_batch(requests: list[dict]) -> str:
    """Submit a batch of requests to Anthropic Batch API.

    Each request dict has: {"custom_id": str, "prompt": str, "system": str, "schema": type[BaseModel] | None, "model": str | None}
    Returns batch_id for polling.
    """
    if Anthropic is None:
        raise ImportError("The 'anthropic' package is required.")

    api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not api_key:
        raise ValueError("ANTHROPIC_API_KEY environment variable not set.")

    # Unset CLAUDECODE to prevent interference when running inside Claude Code
    os.environ.pop("CLAUDECODE", None)

    client = Anthropic(api_key=api_key)
    
    batch_requests = []
    
    for req in requests:
        custom_id = req.get("custom_id", str(uuid.uuid4()))
        prompt = req["prompt"]
        system = req.get("system", "")
        schema = req.get("schema")
        model = req.get("model")
        
        full_user_content = prompt
        
        params = {
            "model": model or os.environ.get("CLAUDE_MODEL") or DEFAULT_MODEL,
            "max_tokens": 4096,
            "messages": [{"role": "user", "content": full_user_content}]
        }

        if schema:
            params["response_format"] = {
                "type": "json_schema",
                "json_schema": schema.model_json_schema(),
            }
        
        system_arg = system
        if system:
            system_arg = [{
                "type": "text",
                "text": system,
                "cache_control": {"type": "ephemeral"},
            }]
        params["system"] = system_arg
            
        batch_requests.append({
            "custom_id": custom_id,
            "params": params
        })
        
    batch = client.batches.create(requests=batch_requests)
    return batch.id


def poll_batch(batch_id: str, timeout: int = 3600) -> list[dict]:
    """Poll for batch completion. Returns list of {custom_id, result} dicts.
    
    Result contains the text content or extracted JSON.
    """
    if Anthropic is None:
        raise ImportError("The 'anthropic' package is required.")

    api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not api_key:
        raise ValueError("ANTHROPIC_API_KEY environment variable not set.")

    # Unset CLAUDECODE to prevent interference when running inside Claude Code
    os.environ.pop("CLAUDECODE", None)

    client = Anthropic(api_key=api_key)
    
    start_time = time.time()
    while True:
        batch = client.batches.retrieve(batch_id)
        if batch.processing_status == "ended":
            break
        if time.time() - start_time > timeout:
            raise TimeoutError(f"Batch {batch_id} timed out after {timeout}s")
        time.sleep(10)
        
    results = []
    
    try:
        for item in client.batches.results(batch_id):
            custom_id = item.custom_id
            result_obj = item.result
            
            if result_obj.type == "succeeded":
                message = result_obj.message
                text = message.content[0].text
                
                # Record usage
                u = message.usage
                rec = _CallRecord(
                    caller="batch",
                    model=message.model,
                    input_tokens=u.input_tokens,
                    output_tokens=u.output_tokens,
                    cache_creation_input_tokens=getattr(u, "cache_creation_input_tokens", 0) or 0,
                    cache_read_input_tokens=getattr(u, "cache_read_input_tokens", 0) or 0,
                )
                usage_tracker.record(rec)
                
                results.append({"custom_id": custom_id, "text": text, "status": "succeeded"})
            else:
                results.append({"custom_id": custom_id, "status": "failed", "error": result_obj.error})
                
    except Exception as e:
        log.error(f"Error fetching batch results: {e}")
        
    return results


def call_claude(
    prompt: str,
    system: str = "",
    schema: type[BaseModel] | None = None,
    model: str | None = None,
    caller: str = "",
    batch_mode: bool = False,
) -> str | dict:
    """Call Anthropic API and return the response.

    Args:
        prompt: The user message to send.
        system: Optional system prompt.
        schema: If provided, uses structured output to return JSON conforming 
                to this Pydantic model schema.
        model: Optional model name.
        caller: Label for usage tracking (e.g. "proof.generate", "verifier.repair").
        batch_mode: If True, submits as a batch of 1 and polls for completion.

    Returns:
        Raw text response, or parsed dict if schema is provided.
    """
    if Anthropic is None:
        raise ImportError("The 'anthropic' package is required. Install it with `pip install anthropic`.")

    if _use_gateway():
        from .llm_gateway import call_llm
        return call_llm(prompt, system=system, schema=schema, model=model, caller=caller)

    api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not api_key:
        raise ValueError("ANTHROPIC_API_KEY environment variable not set.")

    # Unset CLAUDECODE to prevent interference when running inside Claude Code
    os.environ.pop("CLAUDECODE", None)

    if batch_mode:
        custom_id = f"req-{uuid.uuid4()}"
        request = {
            "custom_id": custom_id,
            "prompt": prompt,
            "system": system,
            "schema": schema,
            "model": model
        }
        
        log.info(f"Submitting batch request for {caller}...")
        batch_id = submit_batch([request])
        log.info(f"Batch submitted: {batch_id}. Waiting for results...")
        
        results = poll_batch(batch_id)
        
        for res in results:
            if res["custom_id"] == custom_id:
                if res["status"] == "succeeded":
                    text = res["text"]
                    if schema:
                        # If response_format was used, text should be valid JSON
                        return json.loads(text)
                    return text
                else:
                    raise RuntimeError(f"Batch request failed: {res.get('error')}")
        
        raise RuntimeError("Batch completed but result not found.")

    client = Anthropic(api_key=api_key)
    
    full_user_content = prompt
    kwargs = {}
    
    if schema:
        # Use native structured output
        kwargs["response_format"] = {
            "type": "json_schema",
            "json_schema": schema.model_json_schema(),
        }
    
    model_to_use = model or os.environ.get("CLAUDE_MODEL") or DEFAULT_MODEL

    system_arg: str | list = system
    if system:
        system_arg = [{
            "type": "text",
            "text": system,
            "cache_control": {"type": "ephemeral"},
        }]

    max_retries = 3
    text = ""

    for attempt in range(max_retries):
        try:
            response = client.messages.create(
                model=model_to_use,
                max_tokens=4096,
                system=system_arg,
                messages=[
                    {"role": "user", "content": full_user_content}
                ],
                **kwargs
            )
            text = response.content[0].text

            u = response.usage
            rec = _CallRecord(
                caller=caller,
                model=model_to_use,
                input_tokens=u.input_tokens,
                output_tokens=u.output_tokens,
                cache_creation_input_tokens=getattr(u, "cache_creation_input_tokens", 0) or 0,
                cache_read_input_tokens=getattr(u, "cache_read_input_tokens", 0) or 0,
            )
            usage_tracker.record(rec)
            log.debug(
                "call_claude [%s] in=%d out=%d cache_write=%d cache_read=%d",
                caller, rec.input_tokens, rec.output_tokens,
                rec.cache_creation_input_tokens, rec.cache_read_input_tokens,
            )
            break
        except RateLimitError:
            if attempt == max_retries - 1:
                raise
            sleep_time = (2 ** attempt) * 1
            time.sleep(sleep_time)
        except APIError as e:
            raise RuntimeError(f"Anthropic API error: {e}")

    if schema is None:
        return text

    # With response_format, text should be valid JSON. Fall back to extraction if not.
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        return _extract_json(text)


def _extract_json(text: str) -> dict:
    """Extract JSON from a response that may contain markdown fences or surrounding text."""
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        pass

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

    raise ValueError(f"Could not extract valid JSON from response:\n{text[:500]}")
