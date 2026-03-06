"""Rosetta Stone generator: extract Lean declarations and pair them with NL proofs via Claude."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Literal

from pydantic import BaseModel

# ---------------------------------------------------------------------------
# Pydantic schemas
# ---------------------------------------------------------------------------


class NLProof(BaseModel):
    statement: str
    strategy: str  # direct, contradiction, induction, cases, definition
    assumptions: list[str]
    steps: list[str]
    dependencies: list[str]


class PairMetadata(BaseModel):
    domain: str
    tags: list[str]
    lean_tactics_used: list[str]
    complexity: Literal["trivial", "simple", "moderate", "complex"]
    related_economics_concepts: list[str]


class RosettaPair(BaseModel):
    id: str
    source: Literal["mathlib", "pipeline"]
    mathlib_module: str
    mathlib_name: str
    lean_code: str
    nl_proof: NLProof
    metadata: PairMetadata


# ---------------------------------------------------------------------------
# Lean declaration extraction
# ---------------------------------------------------------------------------

# Keywords that start a declaration we care about
DECL_KEYWORDS = {"theorem", "lemma", "def", "abbrev", "class", "instance", "structure"}

# Patterns to skip entirely
SKIP_PATTERNS = [
    re.compile(r"^\s*@\[deprecated"),              # deprecated entries
    re.compile(r"^\s*alias\b"),                     # pure alias lines
    re.compile(r"^\s*attribute\s*\["),              # attribute assignments
    re.compile(r"^\s*macro\b"),                     # tactic macros
    re.compile(r"^\s*macro_rules\b"),               # macro rules
    re.compile(r"^\s*meta\s+def\b"),                # metaprogramming
    re.compile(r"^\s*extend_docs\b"),               # doc extension commands
    re.compile(r"^\s*@\[inherit_doc\b.*\]\s*$"),    # standalone inherit_doc lines
    re.compile(r"^\s*infixl?\b"),                   # notation declarations
    re.compile(r"^\s*notation\b"),                  # notation declarations
]


class RawDeclaration:
    """A raw Lean declaration extracted from source."""

    def __init__(
        self,
        name: str,
        keyword: str,
        full_text: str,
        doc_comment: str | None,
        attributes: str | None,
        file_path: str,
        line_number: int,
    ):
        self.name = name
        self.keyword = keyword
        self.full_text = full_text
        self.doc_comment = doc_comment
        self.attributes = attributes
        self.file_path = file_path
        self.line_number = line_number

    def __repr__(self) -> str:
        return f"RawDeclaration({self.keyword} {self.name}, line {self.line_number})"


def _is_section_marker(line: str) -> bool:
    """Check if a line is a section/namespace/end marker or variable declaration."""
    stripped = line.strip()
    return bool(
        re.match(r"^(section|end|namespace|open|variable|universe|set_option)\b", stripped)
        or re.match(r"^@\[expose\]", stripped)
        or re.match(r"^public\s+section", stripped)
        or stripped.startswith("public import")
        or stripped.startswith("import ")
        or stripped == "module"
        or stripped == ""
    )


def _starts_declaration(line: str) -> str | None:
    """If the line starts a declaration, return the keyword. Else None."""
    stripped = line.strip()
    # Handle lines that start with attributes then a keyword
    # e.g. "@[simp] lemma ..." or "@[to_dual] instance ..."
    text = stripped
    # Strip leading attribute blocks
    while text.startswith("@["):
        bracket_depth = 0
        i = 0
        for i, ch in enumerate(text):
            if ch == "[":
                bracket_depth += 1
            elif ch == "]":
                bracket_depth -= 1
                if bracket_depth == 0:
                    break
        text = text[i + 1 :].strip()

    # Check for protection/visibility modifiers
    for modifier in [
        "protected",
        "private",
        "noncomputable",
        "unsafe",
        "partial",
        "nonrec",
    ]:
        if text.startswith(modifier + " "):
            text = text[len(modifier) + 1 :].strip()

    # Now check for declaration keywords
    for kw in DECL_KEYWORDS:
        if text.startswith(kw + " ") or text.startswith(kw + "\n"):
            return kw
    return None


def _extract_name(text: str, keyword: str) -> str:
    """Extract the declaration name from its text."""
    # Find the keyword in the text, then grab the name after it
    # Handle: "lemma le_refl ...", "instance instTransLE ...", "class Preorder ...",
    #         "def WCovBy ...", "instance [Preorder α] : Std.LawfulOrderLT α where"
    lines = text.strip().split("\n")
    first_line = lines[0].strip()

    # Strip attributes
    cleaned = first_line
    while cleaned.startswith("@["):
        bracket_depth = 0
        for i, ch in enumerate(cleaned):
            if ch == "[":
                bracket_depth += 1
            elif ch == "]":
                bracket_depth -= 1
                if bracket_depth == 0:
                    break
        cleaned = cleaned[i + 1 :].strip()

    # Strip modifiers
    for modifier in [
        "protected",
        "private",
        "noncomputable",
        "unsafe",
        "partial",
        "nonrec",
    ]:
        if cleaned.startswith(modifier + " "):
            cleaned = cleaned[len(modifier) + 1 :].strip()

    # Now should start with keyword
    if cleaned.startswith(keyword + " "):
        rest = cleaned[len(keyword) + 1 :].strip()
    else:
        return "<unknown>"

    # For instances, the name might be implicit
    # e.g. "instance [Preorder α] : Std.LawfulOrderLT α where"
    # or "instance instTransLE : @Trans ..."
    if keyword == "instance":
        # Check if next token is [ or ( or : (anonymous instance)
        if rest.startswith(("[", "(", ":")):
            # Anonymous instance - create name from the type
            # Find the : and use what comes after
            colon_idx = rest.find(":")
            if colon_idx != -1:
                type_part = rest[colon_idx + 1 :].strip()
                # Take first significant token
                name = re.split(r"[\s\[\({]", type_part)[0]
                return f"instance_{name}"
            return "instance_anonymous"

    # For structures with namespaced names like "PartialOrder.mk'"
    # Take the first whitespace-delimited token, allowing dots
    match = re.match(r"([A-Za-z_][\w.']*)", rest)
    if match:
        return match.group(1)

    return "<unknown>"


def _should_skip(text: str) -> bool:
    """Check if a declaration should be skipped based on content patterns."""
    for pattern in SKIP_PATTERNS:
        if pattern.search(text.split("\n")[0]):
            return True
    # Skip standalone alias lines
    stripped = text.strip()
    if stripped.startswith("alias "):
        return True
    return False


def _has_deprecated_attr(text: str) -> bool:
    """Check if the first line has a @[deprecated ...] attribute."""
    first_line = text.strip().split("\n")[0]
    return bool(re.search(r"@\[deprecated\b", first_line))


def _is_trivial_instance(text: str) -> bool:
    """Check if an instance is trivially just inferInstance or a single field constructor."""
    body = text.strip()
    # "instance ... := inferInstance" or "instance ... := ⟨...⟩" with single field
    if ":= inferInstance" in body:
        return True
    # Single-field anonymous constructor
    match = re.search(r":=\s*⟨([^⟩]*)⟩\s*$", body, re.DOTALL)
    if match and "," not in match.group(1):
        return True
    # "where" block with just infer_instance calls
    if body.endswith("where") and body.count("\n") <= 1:
        return True
    return False


def extract_declarations(file_path: Path) -> list[RawDeclaration]:
    """Parse a Lean 4 file and extract declarations."""
    content = file_path.read_text(encoding="utf-8")
    lines = content.split("\n")

    declarations: list[RawDeclaration] = []
    current_decl_lines: list[str] = []
    current_doc: str | None = None
    current_attrs: str | None = None
    current_keyword: str | None = None
    current_start_line: int = 0
    pending_doc: str | None = None
    pending_attrs_lines: list[str] = []
    pending_deprecated: bool = False

    def _flush():
        nonlocal current_decl_lines, current_doc, current_attrs, current_keyword, current_start_line
        if current_keyword and current_decl_lines:
            full_text = "\n".join(current_decl_lines).rstrip()
            if not _should_skip(full_text) and not _has_deprecated_attr(full_text):
                name = _extract_name(full_text, current_keyword)
                declarations.append(
                    RawDeclaration(
                        name=name,
                        keyword=current_keyword,
                        full_text=full_text,
                        doc_comment=current_doc,
                        attributes=current_attrs,
                        file_path=str(file_path),
                        line_number=current_start_line,
                    )
                )
        current_decl_lines = []
        current_doc = None
        current_attrs = None
        current_keyword = None

    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()

        # Collect doc comments (single-line /-- ... -/ or multi-line)
        if stripped.startswith("/--"):
            doc_lines = [stripped]
            if "-/" not in stripped[3:]:
                i += 1
                while i < len(lines):
                    doc_lines.append(lines[i])
                    if "-/" in lines[i]:
                        break
                    i += 1
            pending_doc = "\n".join(doc_lines)
            i += 1
            continue

        # Collect module-level doc comments /-! ... -/
        if stripped.startswith("/-!"):
            # Skip module docs — they're section headers, not declaration docs
            if "-/" not in stripped[3:]:
                i += 1
                while i < len(lines):
                    if "-/" in lines[i]:
                        break
                    i += 1
            i += 1
            pending_doc = None
            continue

        # Skip copyright comments /- ... -/
        if stripped.startswith("/-") and not stripped.startswith("/--") and not stripped.startswith("/-!"):
            if "-/" not in stripped[2:]:
                i += 1
                while i < len(lines):
                    if "-/" in lines[i]:
                        break
                    i += 1
            i += 1
            continue

        # Track standalone @[deprecated ...] lines that precede declarations
        if not current_keyword and stripped.startswith("@[deprecated"):
            pending_deprecated = True
            i += 1
            continue

        # Check if this line starts a new declaration
        kw = _starts_declaration(line)
        if kw and not _is_section_marker(line):
            _flush()
            if pending_deprecated:
                # Skip this declaration — it's deprecated
                pending_deprecated = False
                pending_doc = None
                # Consume the declaration body
                i += 1
                while i < len(lines):
                    next_stripped = lines[i].strip()
                    # Stop at empty line or next top-level construct
                    if not next_stripped:
                        break
                    if _starts_declaration(lines[i]) and not _is_section_marker(lines[i]):
                        break
                    if _is_section_marker(lines[i]):
                        break
                    i += 1
                continue
            current_keyword = kw
            current_doc = pending_doc
            current_start_line = i + 1  # 1-indexed
            current_decl_lines = [line]
            pending_doc = None
            pending_attrs_lines = []
            pending_deprecated = False
            i += 1
            continue

        # Check if this is a section marker or other non-declaration line
        if _is_section_marker(line) and not current_keyword:
            pending_doc = None
            pending_deprecated = False
            i += 1
            continue

        # If we're inside a declaration, continue collecting lines
        if current_keyword:
            # Check if this line could be a new top-level construct
            if stripped and not stripped.startswith("--") and _is_section_marker(line):
                _flush()
                i += 1
                continue
            # Check for alias lines that follow a declaration (these terminate the current decl)
            if stripped.startswith("alias ") and not stripped.startswith("alias :="):
                _flush()
                i += 1
                continue
            # Check for standalone deprecated annotations between declarations
            if stripped.startswith("@[deprecated"):
                _flush()
                # Skip the deprecated line and what follows
                i += 1
                # Consume the next declaration that has deprecated
                while i < len(lines) and lines[i].strip():
                    i += 1
                continue
            # Check for lines that should terminate the current declaration
            # (macro, notation, infixl, extend_docs, attribute lines)
            if any(p.match(stripped) for p in SKIP_PATTERNS):
                _flush()
                i += 1
                continue
            current_decl_lines.append(line)
        else:
            # Not inside a declaration — skip
            pending_doc = None if stripped and not stripped.startswith("@[") else pending_doc

        i += 1

    _flush()
    return declarations


def filter_declarations(decls: list[RawDeclaration]) -> list[RawDeclaration]:
    """Remove declarations that should be excluded from the corpus."""
    filtered = []
    for d in decls:
        # Skip deprecated
        if d.attributes and "@[deprecated" in d.attributes:
            continue
        # Skip trivial anonymous instances with no proof content
        if d.keyword == "instance" and _is_trivial_instance(d.full_text):
            continue
        filtered.append(d)
    return filtered


# ---------------------------------------------------------------------------
# Mechanical NL generation (no Claude needed)
# ---------------------------------------------------------------------------

# Known tactics to extract from proof bodies
KNOWN_TACTICS = [
    "simp", "rfl", "rw", "rewrite", "exact", "apply", "intro", "intros",
    "cases", "rcases", "obtain", "induction", "constructor", "ext",
    "funext", "have", "let", "show", "calc", "conv", "ring", "linarith",
    "omega", "norm_num", "decide", "trivial", "assumption", "contradiction",
    "absurd", "exfalso", "push_neg", "by_contra", "by_cases", "split",
    "left", "right", "use", "exists", "refine", "specialize", "grind",
    "aesop", "tauto", "simpa", "field_simp", "ring_nf", "gcongr",
    "positivity", "norm_cast", "push_cast", "split_ifs", "congr",
    "subst", "injections", "simp_all", "first", "try",
]


def _extract_tactics(text: str) -> list[str]:
    """Extract tactic names used in a proof body."""
    found = []
    for tactic in KNOWN_TACTICS:
        # Match tactic as a word boundary
        if re.search(rf"\b{re.escape(tactic)}\b", text):
            found.append(tactic)
    return found


def _extract_proof_body(text: str) -> tuple[str | None, str]:
    """Extract the proof body and determine if term-mode or tactic-mode.

    Returns (mode, body) where mode is 'term', 'tactic', 'where', or 'none'.
    """
    # Find := or by
    # Handle multi-line: search whole text
    stripped = text.strip()

    # Check for 'where' blocks (class/instance definitions)
    if re.search(r"\bwhere\s*$", stripped, re.MULTILINE):
        where_idx = stripped.rfind("where")
        return "where", stripped[where_idx:]

    # Check for ':= by' (tactic mode)
    by_match = re.search(r":=\s*by\b", stripped)
    if by_match:
        return "tactic", stripped[by_match.end():]

    # Check for standalone 'by' after type signature
    by_match = re.search(r"\bby\b", stripped)
    if by_match and ":=" not in stripped[:by_match.start()]:
        return "tactic", stripped[by_match.end():]

    # Check for ':=' (term mode)
    eq_match = re.search(r":=", stripped)
    if eq_match:
        return "term", stripped[eq_match.end():].strip()

    return "none", ""


def _extract_dependencies_from_body(body: str) -> list[str]:
    """Extract likely dependency names from a proof body."""
    deps = []
    # Match capitalized identifiers that look like lemma/theorem references
    # e.g. Preorder.le_refl, Or.inl, le_trans, lt_irrefl
    for m in re.finditer(r"\b([A-Z][\w.]*\.[\w.]+|[a-z_][\w]*)\b", body):
        name = m.group(1)
        # Filter out keywords and common noise
        if name in {"fun", "if", "then", "else", "let", "have", "show",
                     "match", "with", "do", "return", "true", "false",
                     "not", "and", "or", "this", "self", "rfl"}:
            continue
        if name in KNOWN_TACTICS:
            continue
        # Keep names that look like lemma references
        if "." in name or "_" in name:
            if name not in deps:
                deps.append(name)
    return deps[:10]  # cap at 10


def _doc_to_statement(doc: str | None, name: str, keyword: str) -> str:
    """Convert a doc comment to a statement, or generate a generic one."""
    if doc:
        # Strip /-- and -/ markers
        cleaned = re.sub(r"^/--\s*", "", doc)
        cleaned = re.sub(r"\s*-/\s*$", "", cleaned)
        cleaned = cleaned.strip()
        if cleaned:
            return cleaned
    return f"{keyword.capitalize()} `{name}`."


def _try_mechanical_nl(decl: RawDeclaration) -> dict | None:
    """Try to generate NL description mechanically. Returns dict or None if Claude needed."""
    text = decl.full_text
    keyword = decl.keyword
    name = decl.name

    mode, body = _extract_proof_body(text)

    # --- Definitions (def, abbrev, class, structure) ---
    if keyword in ("class", "structure"):
        return {
            "name": name,
            "nl_statement": _doc_to_statement(decl.doc_comment, name, keyword),
            "nl_strategy": "definition",
            "nl_assumptions": [],
            "nl_steps": [f"Defines the {keyword} `{name}`."],
            "nl_dependencies": [],
            "lean_tactics_used": _extract_tactics(body) if mode == "tactic" else [],
            "complexity": "trivial",
            "related_economics_concepts": [],
        }

    if keyword in ("def", "abbrev") and mode in ("term", "none", "where"):
        deps = _extract_dependencies_from_body(body) if body else []
        return {
            "name": name,
            "nl_statement": _doc_to_statement(decl.doc_comment, name, keyword),
            "nl_strategy": "definition",
            "nl_assumptions": [],
            "nl_steps": [f"Defined as `{body.strip().split(chr(10))[0][:80]}`." if body.strip() else f"Definition of `{name}`."],
            "nl_dependencies": deps,
            "lean_tactics_used": [],
            "complexity": "trivial",
            "related_economics_concepts": [],
        }

    # --- Term-mode one-liners ---
    if mode == "term":
        body_stripped = body.strip()
        first_line = body_stripped.split("\n")[0].strip()

        # Very short term proofs (single reference, constructor, flip, etc.)
        if body_stripped.count("\n") <= 1 and len(body_stripped) < 150:
            deps = _extract_dependencies_from_body(body_stripped)
            step = f"Directly applies `{first_line}`." if first_line else "Direct proof."
            return {
                "name": name,
                "nl_statement": _doc_to_statement(decl.doc_comment, name, keyword),
                "nl_strategy": "direct",
                "nl_assumptions": [],
                "nl_steps": [step],
                "nl_dependencies": deps,
                "lean_tactics_used": [],
                "complexity": "trivial",
                "related_economics_concepts": [],
            }

    # --- Simple tactic proofs ---
    if mode == "tactic":
        body_stripped = body.strip()
        tactics = _extract_tactics(body_stripped)
        lines = [l.strip() for l in body_stripped.split("\n") if l.strip() and not l.strip().startswith("--")]

        # Single-tactic proofs: by rfl, by simp, by grind, by exact X, by infer_instance
        if len(lines) <= 1:
            tactic = lines[0] if lines else body_stripped.strip()
            if tactic in ("rfl", "trivial", "decide"):
                return {
                    "name": name,
                    "nl_statement": _doc_to_statement(decl.doc_comment, name, keyword),
                    "nl_strategy": "direct",
                    "nl_assumptions": [],
                    "nl_steps": ["Holds by definitional equality."],
                    "nl_dependencies": [],
                    "lean_tactics_used": [tactic],
                    "complexity": "trivial",
                    "related_economics_concepts": [],
                }
            if tactic.startswith("simp") or tactic.startswith("grind"):
                return {
                    "name": name,
                    "nl_statement": _doc_to_statement(decl.doc_comment, name, keyword),
                    "nl_strategy": "direct",
                    "nl_assumptions": [],
                    "nl_steps": ["Follows by simplification/automated reasoning."],
                    "nl_dependencies": [],
                    "lean_tactics_used": tactics,
                    "complexity": "trivial",
                    "related_economics_concepts": [],
                }
            if tactic.startswith("exact ") or tactic.startswith("apply "):
                ref = tactic.split(None, 1)[1] if " " in tactic else ""
                deps = _extract_dependencies_from_body(ref)
                return {
                    "name": name,
                    "nl_statement": _doc_to_statement(decl.doc_comment, name, keyword),
                    "nl_strategy": "direct",
                    "nl_assumptions": [],
                    "nl_steps": [f"Directly applies `{ref}`."],
                    "nl_dependencies": deps,
                    "lean_tactics_used": tactics,
                    "complexity": "trivial",
                    "related_economics_concepts": [],
                }
            if "infer_instance" in tactic or "inferInstance" in tactic:
                return {
                    "name": name,
                    "nl_statement": _doc_to_statement(decl.doc_comment, name, keyword),
                    "nl_strategy": "direct",
                    "nl_assumptions": [],
                    "nl_steps": ["Instance inferred automatically from existing instances."],
                    "nl_dependencies": [],
                    "lean_tactics_used": tactics,
                    "complexity": "trivial",
                    "related_economics_concepts": [],
                }
            # Catch-all for single automation tactics
            _AUTO_TACTICS = {
                "norm_num", "linarith", "omega", "ring", "ring_nf",
                "positivity", "aesop", "tauto", "contradiction",
                "assumption", "norm_cast", "push_neg", "simp_all",
                "field_simp", "decide", "gcongr", "Abel", "group",
            }
            first_word = tactic.split()[0] if tactic else ""
            if first_word in _AUTO_TACTICS:
                return {
                    "name": name,
                    "nl_statement": _doc_to_statement(decl.doc_comment, name, keyword),
                    "nl_strategy": "direct",
                    "nl_assumptions": [],
                    "nl_steps": [f"Follows by `{first_word}`."],
                    "nl_dependencies": [],
                    "lean_tactics_used": tactics,
                    "complexity": "trivial",
                    "related_economics_concepts": [],
                }

        # Short tactic proofs with only standard tactics
        _SIMPLE_PREFIXES = [
            "simp", "rw", "rewrite", "exact", "apply", "intro", "intros",
            "rfl", "trivial", "grind", "simpa", "constructor", "ext",
            "funext", "norm_num", "norm_cast", "push_cast", "push_neg",
            "linarith", "omega", "ring", "ring_nf", "field_simp",
            "congr", "gcongr", "positivity", "aesop", "tauto", "decide",
            "cases", "rcases", "obtain", "split", "left", "right",
            "use", "refine", "have", "let", "show", "contradiction",
            "absurd", "exfalso", "by_contra", "by_cases", "subst",
            "injections", "assumption", "simp_all", "split_ifs",
            "specialize", "calc", "conv", "next", "\u00b7",
        ]
        simple_only = all(
            any(l.startswith(t) for t in _SIMPLE_PREFIXES)
            for l in lines
        )
        if len(lines) <= 5 and simple_only:
            deps = _extract_dependencies_from_body(body_stripped)
            steps = [f"Apply `{l[:60]}`." for l in lines]
            return {
                "name": name,
                "nl_statement": _doc_to_statement(decl.doc_comment, name, keyword),
                "nl_strategy": "direct",
                "nl_assumptions": [],
                "nl_steps": steps,
                "nl_dependencies": deps,
                "lean_tactics_used": tactics,
                "complexity": "simple",
                "related_economics_concepts": [],
            }

    # --- Instance with 'where' block ---
    if keyword == "instance" and mode == "where":
        deps = _extract_dependencies_from_body(body)
        return {
            "name": name,
            "nl_statement": _doc_to_statement(decl.doc_comment, name, keyword),
            "nl_strategy": "definition",
            "nl_assumptions": [],
            "nl_steps": ["Construct the instance by providing the required fields."],
            "nl_dependencies": deps,
            "lean_tactics_used": _extract_tactics(body),
            "complexity": "trivial",
            "related_economics_concepts": [],
        }

    # Can't handle mechanically — needs Claude
    return None


# ---------------------------------------------------------------------------
# NL proof generation via Claude
# ---------------------------------------------------------------------------

SYSTEM_PROMPT_PATH = Path(__file__).resolve().parent.parent / "prompts" / "rosetta_stone.md"
BATCH_SIZE = 32
MAX_RETRIES = 3


def _load_system_prompt() -> str:
    return SYSTEM_PROMPT_PATH.read_text(encoding="utf-8")


def _call_claude(prompt: str, system: str) -> str | dict:
    """Call Claude CLI with retry logic for resilience under concurrent load."""
    import os
    import subprocess
    import time

    full_prompt = f"{system}\n\n{prompt}"
    env = {k: v for k, v in os.environ.items() if k != "CLAUDECODE"}

    for attempt in range(MAX_RETRIES):
        try:
            result = subprocess.run(
                ["claude", "-p", full_prompt, "--output-format", "json", "--model", "haiku"],
                capture_output=True,
                text=True,
                timeout=300,
                env=env,
            )

            if result.returncode != 0:
                raise RuntimeError(f"Claude CLI failed: {result.stderr[:200]}")

            envelope = json.loads(result.stdout)
            text = envelope.get("result", result.stdout)
            return _extract_json_from_text(text)
        except (RuntimeError, json.JSONDecodeError, ValueError, subprocess.TimeoutExpired) as e:
            if attempt < MAX_RETRIES - 1:
                wait = 2 ** attempt * 5  # 5s, 10s, 20s
                print(f"    [retry {attempt + 1}/{MAX_RETRIES}] {e} — waiting {wait}s...")
                time.sleep(wait)
            else:
                raise


def _extract_json_from_text(text: str) -> list | dict:
    """Extract JSON from response text (may contain markdown fences)."""
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

    for start_char, end_char in [("[", "]"), ("{", "}")]:
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
                            return json.loads(text[start : i + 1])
                        except json.JSONDecodeError:
                            break

    raise ValueError(f"Could not extract valid JSON from response:\n{text[:500]}")


def generate_nl_proofs(
    decls: list[RawDeclaration], module_name: str
) -> list[dict]:
    """Generate NL proofs: mechanical for trivial cases, Claude for the rest."""
    # Phase 1: Try mechanical generation for each declaration
    results: list[dict | None] = []
    claude_indices: list[int] = []

    for i, d in enumerate(decls):
        mechanical = _try_mechanical_nl(d)
        if mechanical is not None:
            results.append(mechanical)
        else:
            results.append(None)  # placeholder
            claude_indices.append(i)

    mechanical_count = len(decls) - len(claude_indices)
    print(
        f"  Mechanical: {mechanical_count}/{len(decls)} | "
        f"Claude needed: {len(claude_indices)}"
    )

    if not claude_indices:
        return results  # type: ignore[return-value]

    # Phase 2: Batch the remaining declarations for Claude
    system = _load_system_prompt()
    claude_decls = [decls[i] for i in claude_indices]

    for batch_start in range(0, len(claude_decls), BATCH_SIZE):
        batch = claude_decls[batch_start : batch_start + BATCH_SIZE]
        print(
            f"  Claude batch {batch_start // BATCH_SIZE + 1}/"
            f"{(len(claude_decls) + BATCH_SIZE - 1) // BATCH_SIZE} "
            f"({len(batch)} declarations)..."
        )

        decl_texts = []
        for j, d in enumerate(batch):
            header = f"### Declaration {j + 1}: `{d.name}` ({d.keyword})"
            doc = f"Doc comment: {d.doc_comment}" if d.doc_comment else "No doc comment."
            decl_texts.append(f"{header}\n{doc}\n\n```lean4\n{d.full_text}\n```")

        prompt = (
            f"Module: `{module_name}`\n\n"
            f"Generate NL proof descriptions for the following {len(batch)} Lean 4 declarations. "
            f"Return a JSON array with one object per declaration, in order.\n\n"
            f"Each object should have these fields:\n"
            f"- `name`: the Lean name (string)\n"
            f"- `nl_statement`: plain math description (string)\n"
            f"- `nl_strategy`: one of direct/contradiction/induction/cases/definition (string)\n"
            f"- `nl_assumptions`: list of assumptions (list[str])\n"
            f"- `nl_steps`: proof steps in plain language (list[str])\n"
            f"- `nl_dependencies`: Lean names of dependencies used (list[str])\n"
            f"- `lean_tactics_used`: tactics appearing in the proof (list[str])\n"
            f"- `complexity`: one of trivial/simple/moderate/complex (string)\n"
            f"- `related_economics_concepts`: connections to microeconomics (list[str])\n\n"
            + "\n\n".join(decl_texts)
        )

        result = _call_claude(prompt, system)

        if isinstance(result, dict):
            result = [result]

        # Fill in the placeholders
        for j, r in enumerate(result):
            global_idx = batch_start + j
            if global_idx < len(claude_indices):
                results[claude_indices[global_idx]] = r

    return results  # type: ignore[return-value]


# ---------------------------------------------------------------------------
# Assembly
# ---------------------------------------------------------------------------


def assemble_pairs(
    decls: list[RawDeclaration],
    nl_results: list[dict],
    module_name: str,
) -> list[RosettaPair]:
    """Combine raw declarations with NL results into RosettaPair objects."""
    pairs = []
    seen_ids: dict[str, int] = {}
    for i, (decl, nl) in enumerate(zip(decls, nl_results)):
        base_id = f"{module_name}.{nl.get('name', decl.name)}"
        # Ensure uniqueness by appending a suffix for duplicates
        if base_id in seen_ids:
            seen_ids[base_id] += 1
            pair_id = f"{base_id}_{seen_ids[base_id]}"
        else:
            seen_ids[base_id] = 0
            pair_id = base_id

        # Build NLProof
        nl_proof = NLProof(
            statement=nl.get("nl_statement", ""),
            strategy=nl.get("nl_strategy", "direct"),
            assumptions=nl.get("nl_assumptions", []),
            steps=nl.get("nl_steps", []),
            dependencies=nl.get("nl_dependencies", []),
        )

        # Determine complexity
        complexity = nl.get("complexity", "simple")
        if complexity not in ("trivial", "simple", "moderate", "complex"):
            complexity = "simple"

        # Build metadata
        metadata = PairMetadata(
            domain="order_theory",
            tags=["order", "preorder", "partial_order"],
            lean_tactics_used=nl.get("lean_tactics_used", []),
            complexity=complexity,
            related_economics_concepts=nl.get("related_economics_concepts", []),
        )

        pair = RosettaPair(
            id=pair_id,
            source="mathlib",
            mathlib_module=module_name,
            mathlib_name=nl.get("name", decl.name),
            lean_code=decl.full_text,
            nl_proof=nl_proof,
            metadata=metadata,
        )
        pairs.append(pair)

    return pairs


def build_index(pairs_dir: Path) -> dict:
    """Build index.json from all pairs files in the directory."""
    index: dict = {
        "total_pairs": 0,
        "modules": {},
        "complexity_distribution": {"trivial": 0, "simple": 0, "moderate": 0, "complex": 0},
        "files": [],
    }

    for json_file in sorted(pairs_dir.glob("*.json")):
        if json_file.name == "index.json":
            continue
        data = json.loads(json_file.read_text(encoding="utf-8"))
        pairs = data if isinstance(data, list) else data.get("pairs", [])

        file_entry = {
            "file": json_file.name,
            "count": len(pairs),
            "pair_ids": [p.get("id", p.get("mathlib_name", f"unknown_{i}")) for i, p in enumerate(pairs)],
        }
        index["files"].append(file_entry)
        index["total_pairs"] += len(pairs)

        for pair in pairs:
            module = pair.get("mathlib_module", "unknown")
            index["modules"].setdefault(module, 0)
            index["modules"][module] += 1

            complexity = pair.get("metadata", {}).get("complexity", "simple")
            if complexity in index["complexity_distribution"]:
                index["complexity_distribution"][complexity] += 1

    return index


# ---------------------------------------------------------------------------
# Module path resolution
# ---------------------------------------------------------------------------


def resolve_module_files(module: str, mathlib_root: Path) -> list[Path]:
    """Resolve a Lean module path to actual .lean files.

    Handles both:
    - Single file modules: Mathlib.Order.RelClasses -> Mathlib/Order/RelClasses.lean
    - Directory modules: Mathlib.Order.Defs -> all .lean files in Mathlib/Order/Defs/
    """
    rel_path = module.replace(".", "/")
    single_file = mathlib_root / f"{rel_path}.lean"
    dir_path = mathlib_root / rel_path

    if single_file.is_file():
        return [single_file]
    elif dir_path.is_dir():
        return sorted(dir_path.glob("*.lean"))
    else:
        raise FileNotFoundError(
            f"Could not find module {module} at {single_file} or {dir_path}"
        )


# ---------------------------------------------------------------------------
# Batch processing
# ---------------------------------------------------------------------------


def _file_to_module(lean_file: Path, mathlib_root: Path) -> str:
    """Convert a .lean file path to a Lean module name.

    e.g. .lake/packages/mathlib/Mathlib/Order/Basic.lean -> Mathlib.Order.Basic
    """
    rel = lean_file.relative_to(mathlib_root)
    return str(rel.with_suffix("")).replace("/", ".").replace("\\", ".")


def _module_to_output_name(module_name: str) -> str:
    """Convert a module name to a safe filename.

    e.g. Mathlib.Order.Basic -> mathlib_order_basic.json
    """
    return module_name.lower().replace(".", "_") + ".json"


def _process_single_file(
    lean_file: Path,
    module_name: str,
    output_path: Path,
) -> int:
    """Process a single Lean file: extract, generate NL, write output. Returns pair count."""
    decls = filter_declarations(extract_declarations(lean_file))
    if not decls:
        return 0

    nl_results = generate_nl_proofs(decls, module_name)

    n = min(len(decls), len(nl_results))
    pairs = assemble_pairs(decls[:n], nl_results[:n], module_name)

    output_data = {
        "module": module_name,
        "source_files": [str(lean_file)],
        "pairs": [p.model_dump() for p in pairs],
    }

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(output_data, indent=2), encoding="utf-8")
    return len(pairs)


def _process_file_task(
    lean_file: Path,
    module_name: str,
    output_path: Path,
    idx: int,
    total: int,
    resume: bool,
    mathlib_root: Path,
) -> tuple[int, bool, str]:
    """Process a single file, suitable for ThreadPoolExecutor.

    Returns (pair_count, was_skipped, status_message).
    """
    output_name = output_path.name

    # Resume support: skip if output already exists
    if resume and output_path.is_file():
        try:
            existing = json.loads(output_path.read_text(encoding="utf-8"))
            existing_count = len(existing.get("pairs", []))
            msg = (
                f"[{idx + 1}/{total}] SKIP {module_name} "
                f"({existing_count} pairs already exist)"
            )
            return existing_count, True, msg
        except Exception:
            pass  # re-process if file is corrupt

    msg_start = (
        f"[{idx + 1}/{total}] Processing {module_name}..."
    )
    print(msg_start, flush=True)

    try:
        n = _process_single_file(lean_file, module_name, output_path)
        msg = f"[{idx + 1}/{total}] {module_name} -> {n} pairs"
        print(msg, flush=True)
        return n, False, msg
    except Exception as e:
        msg = f"[{idx + 1}/{total}] {module_name} -> FAILED: {e}"
        print(msg, flush=True)
        return 0, False, msg


def _run_all_submodules(args) -> None:
    """Process all .lean files under a module path, with parallel workers."""
    from concurrent.futures import ThreadPoolExecutor, as_completed

    module_prefix = args.module
    mathlib_root = args.mathlib_root
    pairs_dir = args.pairs_dir
    workers = getattr(args, "workers", 6)

    # Find all .lean files under the module path
    rel_path = module_prefix.replace(".", "/")
    base_dir = mathlib_root / rel_path

    if not base_dir.exists():
        # Maybe it's a single file module
        single = mathlib_root / f"{rel_path}.lean"
        if single.is_file():
            lean_files = [single]
        else:
            print(f"ERROR: Cannot find {base_dir} or {single}")
            sys.exit(1)
    else:
        lean_files = sorted(base_dir.rglob("*.lean"))

    # Also check for a .lean file at the same level as the directory
    parent_file = mathlib_root / f"{rel_path}.lean"
    if parent_file.is_file() and parent_file not in lean_files:
        lean_files.insert(0, parent_file)

    print(f"Found {len(lean_files)} .lean files under {module_prefix}")

    # When resuming, skip the expensive pre-scan for files that already have output
    if args.resume:
        need_scan: list[Path] = []
        already_done = 0
        for f in lean_files:
            module_name = _file_to_module(f, mathlib_root)
            output_name = _module_to_output_name(module_name)
            output_path = pairs_dir / output_name
            if output_path.is_file():
                already_done += 1
            else:
                need_scan.append(f)
        print(f"Resume: {already_done} files already done, {len(need_scan)} to scan")
        scan_files = need_scan
    else:
        scan_files = lean_files

    # Pre-scan declarations only for files that need processing
    file_decl_counts: list[tuple[Path, int]] = []
    total_decls = 0
    for f in scan_files:
        n = len(filter_declarations(extract_declarations(f)))
        file_decl_counts.append((f, n))
        total_decls += n

    # Filter out empty files
    work_items = [(f, n) for f, n in file_decl_counts if n > 0]

    # If resuming, also include already-done files so skipping counts are correct
    if args.resume:
        done_items: list[tuple[Path, int]] = []
        for f in lean_files:
            module_name = _file_to_module(f, mathlib_root)
            output_name = _module_to_output_name(module_name)
            output_path = pairs_dir / output_name
            if output_path.is_file():
                done_items.append((f, 0))
        work_items = done_items + work_items

    print(f"New declarations to process: {total_decls}")
    print(f"Files to process: {len(scan_files)} ({len(work_items)} total incl. skips)")
    print(f"Batch size: {BATCH_SIZE} | Workers: {workers}")
    print()
    sys.stdout.flush()

    # Process files in parallel
    total_pairs = 0
    skipped = 0
    failed = 0

    with ThreadPoolExecutor(max_workers=workers) as executor:
        futures = {}
        for idx, (lean_file, decl_count) in enumerate(work_items):
            module_name = _file_to_module(lean_file, mathlib_root)
            output_name = _module_to_output_name(module_name)
            output_path = pairs_dir / output_name

            future = executor.submit(
                _process_file_task,
                lean_file,
                module_name,
                output_path,
                idx,
                len(work_items),
                args.resume,
                mathlib_root,
            )
            futures[future] = module_name

        for future in as_completed(futures):
            module_name = futures[future]
            try:
                pair_count, was_skipped, msg = future.result()
                total_pairs += pair_count
                if was_skipped:
                    skipped += 1
            except Exception as e:
                failed += 1
                print(f"  {module_name} -> EXCEPTION: {e}")

    print(f"\nDone. Total pairs: {total_pairs}, Skipped: {skipped}, Failed: {failed}")

    # Rebuild index
    print("Rebuilding index...")
    index = build_index(pairs_dir)
    index_path = pairs_dir / "index.json"
    index_path.write_text(json.dumps(index, indent=2), encoding="utf-8")
    print(f"Index: {index['total_pairs']} pairs across {len(index['modules'])} modules")
    print(f"Complexity: {index['complexity_distribution']}")


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------


def main():
    parser = argparse.ArgumentParser(
        description="Generate Rosetta Stone NL-Lean proof pairs"
    )
    parser.add_argument(
        "--module",
        help="Lean module path (e.g. Mathlib.Order.Defs)",
    )
    parser.add_argument(
        "--mathlib-root",
        type=Path,
        default=Path(".lake/packages/mathlib"),
        help="Path to mathlib root directory",
    )
    parser.add_argument(
        "--output",
        type=Path,
        help="Output JSON file path",
    )
    parser.add_argument(
        "--build-index",
        action="store_true",
        help="Build index.json from existing pairs files",
    )
    parser.add_argument(
        "--pairs-dir",
        type=Path,
        default=Path("rosetta_stone/pairs"),
        help="Directory containing pairs JSON files",
    )
    parser.add_argument(
        "--extract-only",
        action="store_true",
        help="Only extract declarations, don't call Claude",
    )

    parser.add_argument(
        "--all-submodules",
        action="store_true",
        help="Process all .lean files under --module recursively",
    )
    parser.add_argument(
        "--resume",
        action="store_true",
        help="Skip files that already have output (use with --all-submodules)",
    )
    parser.add_argument(
        "--workers",
        type=int,
        default=6,
        help="Number of parallel workers for file processing (default: 6)",
    )

    args = parser.parse_args()

    if args.build_index:
        print(f"Building index from {args.pairs_dir}...")
        index = build_index(args.pairs_dir)
        index_path = args.pairs_dir / "index.json"
        index_path.write_text(json.dumps(index, indent=2), encoding="utf-8")
        print(f"Index written to {index_path}")
        print(f"  Total pairs: {index['total_pairs']}")
        print(f"  Modules: {index['modules']}")
        print(f"  Complexity: {index['complexity_distribution']}")
        return

    if args.all_submodules:
        if not args.module:
            parser.error("--module is required with --all-submodules")
        _run_all_submodules(args)
        return

    if not args.module:
        parser.error("--module is required unless --build-index is used")
    if not args.output:
        parser.error("--output is required unless --build-index is used")

    # Step 1: Resolve module files
    files = resolve_module_files(args.module, args.mathlib_root)
    print(f"Module {args.module} resolved to {len(files)} file(s):")
    for f in files:
        print(f"  {f}")

    # Step 2: Extract declarations from all files
    all_decls: list[RawDeclaration] = []
    for f in files:
        decls = extract_declarations(f)
        decls = filter_declarations(decls)
        print(f"  {f.name}: {len(decls)} declarations extracted")
        all_decls.extend(decls)

    print(f"\nTotal declarations: {len(all_decls)}")

    if args.extract_only:
        # Print declarations and exit
        for d in all_decls:
            print(f"\n--- {d.keyword} {d.name} (line {d.line_number}) ---")
            print(d.full_text[:200])
        return

    # Step 3: Generate NL proofs via Claude
    print("\nGenerating NL proofs via Claude...")
    nl_results = generate_nl_proofs(all_decls, args.module)

    if len(nl_results) < len(all_decls):
        print(
            f"WARNING: Got {len(nl_results)} NL results for {len(all_decls)} declarations. "
            f"Truncating to shorter list."
        )

    # Step 4: Assemble pairs
    n = min(len(all_decls), len(nl_results))
    pairs = assemble_pairs(all_decls[:n], nl_results[:n], args.module)

    # Step 5: Validate and write
    output_data = {
        "module": args.module,
        "source_files": [str(f) for f in files],
        "pairs": [p.model_dump() for p in pairs],
    }

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(output_data, indent=2), encoding="utf-8")
    print(f"\nWrote {len(pairs)} pairs to {args.output}")

    # Report stats
    complexity_counts: dict[str, int] = {}
    for p in pairs:
        c = p.metadata.complexity
        complexity_counts[c] = complexity_counts.get(c, 0) + 1
    print(f"Complexity distribution: {complexity_counts}")


if __name__ == "__main__":
    main()
