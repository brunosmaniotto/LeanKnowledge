"""Unified LLM gateway — LiteLLM + CLI backends.

All LLM calls in the pipeline go through this module. Model routing is
configured via environment variables with sensible defaults.

Three backends:
  1. LiteLLM (default) — any provider: anthropic/, openai/, deepseek/, gemini/
  2. Claude Code CLI — prefix with cli/claude, uses Max/Pro subscription
  3. Gemini CLI — prefix with cli/gemini, uses Google account

Model string examples:
  anthropic/claude-sonnet-4-20250514       → LiteLLM (API credits)
  deepseek/deepseek-reasoner               → LiteLLM (API credits)
  cli/claude                               → Claude Code CLI (subscription)
  cli/claude/claude-sonnet-4-20250514      → Claude Code CLI with specific model
  cli/gemini                               → Gemini CLI (subscription)
  cli/gemini/gemini-2.5-pro                → Gemini CLI with specific model

For self-hosted models (vLLM, etc.), set LK_MODEL_FAST_B_API_BASE to the
server URL (e.g., http://10.128.0.3:8000/v1). The model string should use
the openai/ prefix (e.g., openai/Goedel-LM/Goedel-Prover-V2-8B).
"""

import json
import os
import subprocess
import time

import litellm


class LLMInfraError(RuntimeError):
    """Infrastructure failure: timeout, crash, auth error, empty output.

    These are NOT proof errors — the LLM never got a chance to try (or its
    output was lost).  Callers should re-queue the item instead of marking
    it as a permanent failure.
    """
    pass

# Defaults — Sonnet for fast/heavy tasks, Goedel-Prover available for Agent 2 ensemble
MODEL_FAST_A = os.environ.get("LK_MODEL_FAST_A", "anthropic/claude-sonnet-4-20250514")
MODEL_FAST_B = os.environ.get("LK_MODEL_FAST_B", "openai/Goedel-LM/Goedel-Prover-V2-8B")
MODEL_HEAVY = os.environ.get("LK_MODEL_HEAVY", "anthropic/claude-sonnet-4-20250514")

# Per-model API base URLs for self-hosted models
_MODEL_API_BASES: dict[str, str] = {}
_fast_b_base = os.environ.get("LK_MODEL_FAST_B_API_BASE")
if _fast_b_base:
    _MODEL_API_BASES[MODEL_FAST_B] = _fast_b_base

# CLI tool paths (override if installed in non-standard location)
CLAUDE_CLI = os.environ.get("LK_CLAUDE_CLI", "claude")
GEMINI_CLI = os.environ.get("LK_GEMINI_CLI", "gemini")

# Suppress LiteLLM's verbose logging by default
litellm.suppress_debug_info = True


# ---------------------------------------------------------------------------
# CLI backend (Claude Code / Gemini CLI)
# ---------------------------------------------------------------------------

def _is_cli_model(model: str) -> bool:
    """Check if model string routes to a CLI tool."""
    return model.startswith("cli/")


def _parse_cli_model(model: str) -> tuple[str, str]:
    """Parse 'cli/tool[/model]' into (tool, model_name).

    Examples:
        'cli/claude'                          → ('claude', '')
        'cli/claude/claude-sonnet-4-20250514' → ('claude', 'claude-sonnet-4-20250514')
        'cli/gemini'                          → ('gemini', '')
        'cli/gemini/gemini-2.5-pro'           → ('gemini', 'gemini-2.5-pro')
    """
    parts = model.split("/", 2)
    tool = parts[1] if len(parts) > 1 else ""
    model_name = parts[2] if len(parts) > 2 else ""
    return tool, model_name


def _complete_cli(
    tool: str,
    prompt: str,
    system: str = "",
    model_name: str = "",
    max_tokens: int = 8192,
    cli_timeout: int = 1200,
) -> str:
    """Call Claude Code or Gemini CLI as a subprocess.

    CLI tools don't have a separate system prompt channel, so we
    prepend the system prompt to the user prompt with a separator.

    For long prompts (>6000 chars), pipes via stdin to avoid Windows
    command-line length limits.
    """
    import tempfile

    full_prompt = f"{system}\n\n---\n\n{prompt}" if system else prompt

    # Determine whether to use -p arg or pipe via stdin.
    # Gemini CLI always uses stdin — passing long prompts as -p args
    # causes Gemini to misinterpret the system/user separator.
    use_stdin = len(full_prompt) > 6000 or tool == "gemini"

    if tool == "claude":
        cli_parts = CLAUDE_CLI.split()
        if use_stdin:
            cmd = cli_parts + ["-p", "-"]
        else:
            cmd = cli_parts + ["-p", full_prompt]
        if model_name:
            cmd.extend(["--model", model_name])
    elif tool == "gemini":
        cli_parts = GEMINI_CLI.split()
        if use_stdin:
            cmd = cli_parts + ["-p", "-"]
        else:
            cmd = cli_parts + ["-p", full_prompt]
        if model_name:
            cmd.extend(["--model", model_name])
    else:
        raise ValueError(f"Unknown CLI tool: {tool}. Use 'claude' or 'gemini'.")

    stdin_data = full_prompt if use_stdin else None

    # Retry on transient CLI failures (rate limits, auth hiccups, etc.)
    for attempt in range(5):
        try:
            run_kwargs = dict(
                capture_output=True,
                text=True,
                timeout=cli_timeout,
                encoding="utf-8",
                errors="replace",
            )
            if stdin_data is not None:
                run_kwargs["input"] = stdin_data
            else:
                # Prevent claude from hanging on stdin detection
                run_kwargs["stdin"] = subprocess.DEVNULL
            result = subprocess.run(cmd, **run_kwargs)
        except subprocess.TimeoutExpired:
            raise LLMInfraError(f"CLI {tool} timed out after {cli_timeout}s")
        except OSError as e:
            raise LLMInfraError(
                f"CLI {tool} subprocess error: {e}"
            ) from e

        if result.returncode == 0:
            output = result.stdout.strip()
            if not output:
                raise LLMInfraError(f"CLI {tool} returned empty output")
            return output

        stderr = result.stderr[:500] if result.stderr else "(no stderr)"
        stdout = result.stdout[:500] if result.stdout else ""
        combined = (stderr + stdout).lower()

        # Detect transient failures: rate limits, quota, overloaded, auth
        # hiccups (Gemini CLI often prints "Loaded cached credentials" on
        # transient failures without an explicit "rate" message).
        is_transient = (
            "rate" in combined
            or "quota" in combined
            or "resource" in combined and "exhausted" in combined
            or "overloaded" in combined
            or "429" in combined
            or "503" in combined
            or result.returncode == 1 and not stdout.strip()
        )
        if is_transient and attempt < 4:
            wait = 30 * (2 ** attempt)  # 30s, 60s, 120s, 240s
            print(f"    [CLI] Transient failure, waiting {wait}s "
                  f"(attempt {attempt + 1}/5)...")
            time.sleep(wait)
            continue

        raise LLMInfraError(
            f"CLI {tool} failed (exit {result.returncode}): {stderr}"
        )

    raise LLMInfraError(f"CLI {tool} failed after 5 retries")


def complete(
    model: str,
    prompt: str,
    system: str = "",
    max_tokens: int = 8192,
    temperature: float = 0.0,
    cli_timeout: int = 1200,
) -> str:
    """Call an LLM and return the text response.

    Routes to the appropriate backend:
      - cli/claude or cli/gemini → subprocess call (subscription)
      - anything else → LiteLLM (API credits)

    Args:
        cli_timeout: timeout in seconds for CLI subprocess calls.
            Ignored for LiteLLM API calls (which have their own retry logic).
    """
    # CLI backend — Claude Code or Gemini CLI
    if _is_cli_model(model):
        tool, model_name = _parse_cli_model(model)
        return _complete_cli(
            tool, prompt, system=system,
            model_name=model_name, max_tokens=max_tokens,
            cli_timeout=cli_timeout,
        )

    # LiteLLM backend — all API providers
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
        kwargs["api_key"] = "dummy"  # vLLM and other self-hosted backends require a placeholder key

    # Retry on rate limits and transient errors with exponential backoff
    for attempt in range(5):
        try:
            response = litellm.completion(**kwargs)
            return response.choices[0].message.content
        except Exception as e:
            err_str = str(e).lower()
            is_retryable = (
                "rate_limit" in err_str
                or "peer closed connection" in err_str
                or "incomplete chunked read" in err_str
                or "connection" in err_str and "error" in err_str
                or "internalservererror" in err_str
                or "timeout" in err_str
                or "502" in err_str
                or "503" in err_str
                or "529" in err_str
            )
            if is_retryable and attempt < 4:
                wait = 30 * (2 ** attempt)  # 30s, 60s, 120s, 240s
                print(f"    [LLM] Transient error, retrying in {wait}s: {str(e)[:100]}")
                time.sleep(wait)
                continue
            # Wrap infrastructure failures so callers can distinguish
            # them from proof errors and re-queue the item.
            is_infra = (
                is_retryable
                or "authentication" in err_str
                or "authenticationerror" in err_str
                or "invalid_api_key" in err_str
                or "permission" in err_str
            )
            if is_infra:
                raise LLMInfraError(str(e)) from e
            raise


def _strip_json_fences(text: str) -> str:
    """Strip markdown code fences and other wrappers from a JSON response."""
    import re

    stripped = text.strip()

    # Strip DeepSeek-style <think>...</think> reasoning blocks
    stripped = re.sub(r"<think>.*?</think>", "", stripped, flags=re.DOTALL).strip()
    stripped = re.sub(r"<think>.*", "", stripped, flags=re.DOTALL).strip()

    # Strip markdown fences: ```json ... ``` or ``` ... ```
    fence_match = re.search(r"```(?:json)?\s*\n(.*?)```", stripped, re.DOTALL)
    if fence_match:
        stripped = fence_match.group(1).strip()
    elif stripped.startswith("```"):
        # Fallback: opening fence without closing — strip line-by-line
        lines = stripped.split("\n")
        lines = [l for l in lines if not l.strip().startswith("```")]
        stripped = "\n".join(lines)

    return stripped


def _repair_json_strings(text: str) -> str:
    """Attempt to fix unescaped newlines/tabs inside JSON string values.

    LLMs (especially Gemini) emit multi-line Lean code inside JSON strings
    without escaping newlines, producing invalid JSON like:
        "lean_signature": "lemma foo
          (x : Nat) : True"
    This repairs those by escaping literal newlines/tabs inside string values.
    """
    import re

    # Strategy: replace literal newlines that appear inside JSON string values
    # with \\n. We do this by finding all string literals and escaping within.
    result = []
    in_string = False
    escape_next = False
    for ch in text:
        if escape_next:
            result.append(ch)
            escape_next = False
            continue
        if ch == '\\' and in_string:
            result.append(ch)
            escape_next = True
            continue
        if ch == '"' and not escape_next:
            in_string = not in_string
            result.append(ch)
            continue
        if in_string:
            if ch == '\n':
                result.append('\\n')
            elif ch == '\t':
                result.append('\\t')
            elif ch == '\r':
                continue  # skip carriage returns
            else:
                result.append(ch)
        else:
            result.append(ch)
    return ''.join(result)


def complete_json(
    model: str,
    prompt: str,
    system: str = "",
    max_tokens: int = 8192,
    temperature: float = 0.0,
    retries: int = 2,
) -> dict:
    """Call an LLM and parse the response as JSON.

    Args:
        retries: Number of times to retry on JSON parse failure (re-calls the
            LLM with increased temperature). Default 0 = no retries.
    """
    for attempt in range(1 + retries):
        temp = temperature if attempt == 0 else max(temperature, 0.4)
        text = complete(model, prompt, system=system, max_tokens=max_tokens,
                        temperature=temp)
        stripped = _strip_json_fences(text)
        try:
            return json.loads(stripped)
        except json.JSONDecodeError:
            # Try to repair common issues: unescaped newlines inside
            # JSON string values (LLMs put multi-line Lean code in strings)
            repaired = _repair_json_strings(stripped)
            if repaired != stripped:
                try:
                    return json.loads(repaired)
                except json.JSONDecodeError:
                    pass
            if attempt < retries:
                print(f"    [complete_json] JSON parse failed (attempt "
                      f"{attempt + 1}/{1 + retries})")
                continue
            raise
