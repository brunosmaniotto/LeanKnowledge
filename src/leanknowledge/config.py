"""Centralized configuration and model roll call.

Loads model assignments from a TOML config file, with environment variable
overrides. Before any LLM-spending command, `roll_call()` pings each unique
model to verify its actual identity — catching typos, silent fallbacks, and
connectivity issues before tokens are spent.
"""

import os
import sys
import tomllib
from dataclasses import dataclass, field
from pathlib import Path


# ---------------------------------------------------------------------------
# Config dataclass
# ---------------------------------------------------------------------------

@dataclass
class RunConfig:
    """All model assignments for a pipeline run."""

    # Agent models
    extraction: str = "cli/claude"
    claim_fast_a: str = "anthropic/claude-sonnet-4-20250514"
    claim_fast_b: str = "openai/Goedel-LM/Goedel-Prover-V2-8B"
    claim_arbiter: str = "anthropic/claude-sonnet-4-20250514"
    failure_analyst: str = "anthropic/claude-sonnet-4-20250514"

    # Translator tiers
    direct_model: str = "deepseek/deepseek-reasoner"
    direct_attempts: int = 3
    tier1_model: str = "deepseek/deepseek-reasoner"
    tier1_attempts: int = 7
    tier2_model: str = "gemini/gemini-2.5-pro"
    tier2_attempts: int = 5
    tier3_enabled: bool = True
    tier3_model: str = "gemini/gemini-2.5-pro"
    tier3_prover: str = "gemini/gemini-2.5-pro"
    tier3_attempts: int = 3
    oracle_enabled: bool = False
    oracle_model: str = "anthropic/claude-sonnet-4-20250514"
    oracle_attempts: int = 5
    definition_model: str = "deepseek/deepseek-reasoner"
    definition_escalation_model: str = "gemini/gemini-2.5-pro"
    definition_attempts: int = 6

    # CLI paths
    claude_cli: str = "claude"
    gemini_cli: str = "gemini"

    # Metadata
    config_source: str = "(defaults)"


def load_config(config_path: Path | None = None) -> RunConfig:
    """Load config from TOML file, then apply env var overrides.

    Priority: env vars > TOML file > dataclass defaults.
    """
    cfg = RunConfig()

    # --- Load TOML ---
    if config_path and config_path.exists():
        with open(config_path, "rb") as f:
            raw = tomllib.load(f)
        cfg.config_source = str(config_path)

        models = raw.get("models", {})
        translator = raw.get("translator", {})
        cli = raw.get("cli", {})

        # Models section
        for key in ("extraction", "claim_fast_a", "claim_fast_b",
                     "claim_arbiter", "failure_analyst"):
            if key in models:
                setattr(cfg, key, models[key])

        # Translator section
        for key in ("direct_model", "tier1_model", "tier2_model",
                     "tier3_model", "tier3_prover", "oracle_model",
                     "definition_model", "definition_escalation_model"):
            if key in translator:
                setattr(cfg, key, translator[key])
        for key in ("direct_attempts", "tier1_attempts", "tier2_attempts",
                     "tier3_attempts", "oracle_attempts", "definition_attempts"):
            if key in translator:
                setattr(cfg, key, int(translator[key]))
        for key in ("tier3_enabled", "oracle_enabled"):
            if key in translator:
                setattr(cfg, key, bool(translator[key]))

        # CLI section
        if "claude" in cli:
            cfg.claude_cli = cli["claude"]
        if "gemini" in cli:
            cfg.gemini_cli = cli["gemini"]

    # --- Env var overrides ---
    _env = os.environ.get
    cfg.extraction = _env("LK_EXTRACTION_MODEL", cfg.extraction)
    cfg.claim_fast_a = _env("LK_MODEL_FAST_A", cfg.claim_fast_a)
    cfg.claim_fast_b = _env("LK_MODEL_FAST_B", cfg.claim_fast_b)
    cfg.claim_arbiter = _env("LK_MODEL_HEAVY", cfg.claim_arbiter)
    cfg.failure_analyst = _env("LK_FAILURE_ANALYST_MODEL", cfg.failure_analyst)

    cfg.direct_model = _env("LK_TRANSLATOR_DIRECT_MODEL", cfg.direct_model)
    cfg.direct_attempts = int(_env("LK_TRANSLATOR_DIRECT_ATTEMPTS", str(cfg.direct_attempts)))
    cfg.tier1_model = _env("LK_TRANSLATOR_TIER1_MODEL", cfg.tier1_model)
    cfg.tier1_attempts = int(_env("LK_TRANSLATOR_TIER1_ATTEMPTS", str(cfg.tier1_attempts)))
    cfg.tier2_model = _env("LK_TRANSLATOR_TIER2_MODEL", cfg.tier2_model)
    cfg.tier2_attempts = int(_env("LK_TRANSLATOR_TIER2_ATTEMPTS", str(cfg.tier2_attempts)))
    cfg.tier3_enabled = _env("LK_TRANSLATOR_TIER3_ENABLED", "1" if cfg.tier3_enabled else "0") == "1"
    cfg.tier3_model = _env("LK_TRANSLATOR_TIER3_MODEL", cfg.tier3_model)
    cfg.tier3_prover = _env("LK_TRANSLATOR_TIER3_PROVER", cfg.tier3_prover)
    cfg.tier3_attempts = int(_env("LK_TRANSLATOR_TIER3_ATTEMPTS", str(cfg.tier3_attempts)))
    cfg.oracle_enabled = _env("LK_TRANSLATOR_ORACLE_ENABLED", "1" if cfg.oracle_enabled else "0") == "1"
    cfg.oracle_model = _env("LK_TRANSLATOR_ORACLE_MODEL", cfg.oracle_model)
    cfg.oracle_attempts = int(_env("LK_TRANSLATOR_ORACLE_ATTEMPTS", str(cfg.oracle_attempts)))
    cfg.definition_model = _env("LK_DEFINITION_MODEL", cfg.definition_model)
    cfg.definition_escalation_model = _env("LK_DEFINITION_ESCALATION_MODEL", cfg.definition_escalation_model)
    cfg.definition_attempts = int(_env("LK_DEFINITION_MAX_ATTEMPTS", str(cfg.definition_attempts)))

    cfg.claude_cli = _env("LK_CLAUDE_CLI", cfg.claude_cli)
    cfg.gemini_cli = _env("LK_GEMINI_CLI", cfg.gemini_cli)

    return cfg


def apply_config(cfg: RunConfig) -> None:
    """Push config values into already-imported module globals.

    The agent modules read os.environ at import time into module-level
    globals. Since pipeline.py imports them at the top, those globals are
    already set by the time main() runs. We patch them directly here.
    """
    from . import llm
    from .agents import translator, extraction, failure_analyst, proof_structurer

    # llm.py globals
    llm.MODEL_FAST_A = cfg.claim_fast_a
    llm.MODEL_FAST_B = cfg.claim_fast_b
    llm.MODEL_HEAVY = cfg.claim_arbiter
    llm.CLAUDE_CLI = cfg.claude_cli
    llm.GEMINI_CLI = cfg.gemini_cli

    # translator.py globals
    translator.DIRECT_MODEL = cfg.direct_model
    translator.MAX_DIRECT_ATTEMPTS = cfg.direct_attempts
    translator.TIER1_MODEL = cfg.tier1_model
    translator.MAX_ATTEMPTS_TIER1 = cfg.tier1_attempts
    translator.TIER2_MODEL = cfg.tier2_model
    translator.MAX_ATTEMPTS_TIER2 = cfg.tier2_attempts
    translator.TIER3_ENABLED = cfg.tier3_enabled
    translator.TIER3_MODEL = cfg.tier3_model
    translator.TIER3_PROVER_MODEL = cfg.tier3_prover
    translator.TIER3_ATTEMPTS_PER_LEMMA = cfg.tier3_attempts
    translator.ORACLE_ENABLED = cfg.oracle_enabled
    translator.ORACLE_MODEL = cfg.oracle_model
    translator.ORACLE_MAX_ATTEMPTS = cfg.oracle_attempts
    translator.DEFINITION_MODEL = cfg.definition_model
    translator.DEFINITION_ESCALATION_MODEL = cfg.definition_escalation_model
    translator.DEFINITION_MAX_ATTEMPTS = cfg.definition_attempts

    # failure_analyst.py globals
    failure_analyst.RETRY_DIRECT_ATTEMPTS = cfg.direct_attempts
    failure_analyst.RETRY_TIER1_ATTEMPTS = cfg.tier1_attempts
    failure_analyst.RETRY_TIER2_ATTEMPTS = cfg.tier2_attempts

    # Also set env vars for any code that still reads them directly
    _pairs = [
        ("LK_EXTRACTION_MODEL", cfg.extraction),
        ("LK_MODEL_FAST_A", cfg.claim_fast_a),
        ("LK_MODEL_FAST_B", cfg.claim_fast_b),
        ("LK_MODEL_HEAVY", cfg.claim_arbiter),
        ("LK_CLAUDE_CLI", cfg.claude_cli),
        ("LK_GEMINI_CLI", cfg.gemini_cli),
    ]
    for key, val in _pairs:
        os.environ[key] = val


# ---------------------------------------------------------------------------
# Roll call — live model identity verification
# ---------------------------------------------------------------------------

_ROLL_CALL_PROMPT = "Reply with ONLY your model name and version identifier. Nothing else."

# For CLI tools, we use a flag-based identity check instead of a prompt
_CLI_ROLL_CALL_TIMEOUT = 30  # seconds — just a ping, should be fast


def _backend_label(model: str) -> str:
    if model.startswith("cli/"):
        return "CLI"
    return "API"


def _probe_model(model: str, cfg: RunConfig) -> str:
    """Send a lightweight probe to a model and return its self-reported identity.

    Returns the model's response (trimmed) or an error string prefixed with '!'.
    """
    import subprocess

    if model.startswith("cli/"):
        parts = model.split("/", 2)
        tool = parts[1] if len(parts) > 1 else ""
        model_name = parts[2] if len(parts) > 2 else ""

        if tool == "claude":
            cmd = cfg.claude_cli.split() + ["-p", _ROLL_CALL_PROMPT]
            if model_name:
                cmd.extend(["--model", model_name])
        elif tool == "gemini":
            cmd = cfg.gemini_cli.split() + ["-p", _ROLL_CALL_PROMPT]
            if model_name:
                cmd.extend(["--model", model_name])
        else:
            return f"! Unknown CLI tool: {tool}"

        try:
            result = subprocess.run(
                cmd, capture_output=True, text=True,
                timeout=_CLI_ROLL_CALL_TIMEOUT,
                stdin=subprocess.DEVNULL,
            )
            if result.returncode == 0 and result.stdout.strip():
                return result.stdout.strip()[:120]
            stderr = result.stderr[:200] if result.stderr else "(no output)"
            return f"! CLI error: {stderr}"
        except subprocess.TimeoutExpired:
            return f"! CLI timeout ({_CLI_ROLL_CALL_TIMEOUT}s)"
        except FileNotFoundError:
            return f"! Command not found: {cmd[0]}"
        except OSError as e:
            return f"! {e}"

    else:
        # API model via LiteLLM
        try:
            import litellm
            litellm.suppress_debug_info = True
            response = litellm.completion(
                model=model,
                messages=[{"role": "user", "content": _ROLL_CALL_PROMPT}],
                max_tokens=60,
                temperature=0.0,
            )
            return response.choices[0].message.content.strip()[:120]
        except Exception as e:
            return f"! {type(e).__name__}: {str(e)[:100]}"


def roll_call(cfg: RunConfig, skip_disabled: bool = True) -> bool:
    """Probe every unique model in the config and display results.

    Returns True if all probes succeed, False if any failed.
    """
    # Build ordered list of (role, model_string) pairs
    slots: list[tuple[str, str]] = [
        ("Extraction", cfg.extraction),
        ("Claim (fast A)", cfg.claim_fast_a),
        ("Claim (fast B)", cfg.claim_fast_b),
        ("Claim (arbiter)", cfg.claim_arbiter),
        ("Translator Direct", cfg.direct_model),
        ("Translator Tier 1", cfg.tier1_model),
        ("Translator Tier 2", cfg.tier2_model),
    ]
    if cfg.tier3_enabled:
        slots.append(("Translator Tier 3", cfg.tier3_model))
        slots.append(("Tier 3 Prover", cfg.tier3_prover))
    elif not skip_disabled:
        slots.append(("Translator Tier 3", "(DISABLED)"))

    if cfg.oracle_enabled:
        slots.append(("Oracle", cfg.oracle_model))
    elif not skip_disabled:
        slots.append(("Oracle", "(DISABLED)"))

    slots.extend([
        ("Definitions", cfg.definition_model),
        ("Def. Escalation", cfg.definition_escalation_model),
        ("Failure Analyst", cfg.failure_analyst),
    ])

    # Deduplicate: probe each unique model string only once
    unique_models = list(dict.fromkeys(m for _, m in slots if not m.startswith("(")))
    print(f"\n  Probing {len(unique_models)} unique model(s)...\n")

    probes: dict[str, str] = {}
    for model in unique_models:
        sys.stdout.write(f"    {model} ... ")
        sys.stdout.flush()
        identity = _probe_model(model, cfg)
        probes[model] = identity
        if identity.startswith("!"):
            print(f"FAILED  {identity}")
        else:
            print(f"OK  -->  {identity}")

    # Display the full assignment table
    print(f"\n{'=' * 72}")
    print(f"  LeanKnowledge — Model Roll Call")
    print(f"  Config: {cfg.config_source}")
    print(f"{'=' * 72}")
    print(f"  {'Agent':<22} {'Configured':<30} {'Responds as'}")
    print(f"  {'─' * 20}  {'─' * 28}  {'─' * 18}")

    any_failed = False
    for role, model in slots:
        if model.startswith("("):
            # Disabled tier
            print(f"  {role:<22} {model}")
            continue

        identity = probes.get(model, "?")
        backend = _backend_label(model)

        # Truncate model string for display
        display_model = model if len(model) <= 28 else model[:25] + "..."

        if identity.startswith("!"):
            marker = " *** FAILED ***"
            any_failed = True
        else:
            marker = ""

        print(f"  {role:<22} {display_model:<30} {identity[:40]}{marker}")

    print(f"{'=' * 72}")

    if any_failed:
        print("\n  WARNING: Some models failed to respond. Check configuration.\n")

    return not any_failed
