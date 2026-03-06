from typing import Literal
from pydantic import BaseModel, Field
from enum import Enum
from datetime import datetime


# --- Agent 1: Extraction ---

class StatementType(str, Enum):
    DEFINITION = "definition"
    AXIOM = "axiom"
    PROPOSITION = "proposition"
    THEOREM = "theorem"
    LEMMA = "lemma"
    COROLLARY = "corollary"
    EXAMPLE = "example"
    REMARK = "remark"
    CLAIM = "claim"
    INVOKED_DEPENDENCY = "invoked_dependency"
    IMPLICIT_ASSUMPTION = "implicit_assumption"


class ClaimRole(str, Enum):
    DEFINITION = "definition"
    CLAIMED_RESULT = "claimed_result"
    INVOKED_DEPENDENCY = "invoked_dependency"
    IMPLICIT_ASSUMPTION = "implicit_assumption"


class ExtractedItem(BaseModel):
    id: str
    type: StatementType
    role: ClaimRole = ClaimRole.CLAIMED_RESULT
    statement: str
    proof: str | None = None
    proof_sketch: str | None = None
    dependencies: list[str] = Field(default_factory=list)
    section: str
    labeled: bool = True
    context: str | None = None
    notation_in_scope: dict[str, str] = Field(default_factory=dict)


class ExtractionResult(BaseModel):
    source: str
    items: list[ExtractedItem]
    extraction_tier: Literal["pymupdf", "google_docai"] = "pymupdf"


# --- Agent 5: Proof Structurer ---

class ProofStrategy(str, Enum):
    DIRECT = "direct"
    CONTRADICTION = "contradiction"
    INDUCTION = "induction"
    CONSTRUCTION = "construction"
    CASES = "cases"


class Assumption(BaseModel):
    name: str
    statement: str
    lean_type_hint: str | None = None


class Dependency(BaseModel):
    name: str
    statement: str
    source: str | None = None   # "mathlib", "axiomatized", backlog item ID
    usage: str | None = None    # which step uses it and how


class ProofStep(BaseModel):
    step_number: int
    description: str
    justification: str
    objects_introduced: list[str] = Field(default_factory=list)
    lean_tactic_hint: str | None = None
    substeps: list["ProofStep"] = Field(default_factory=list)


# --- Lean compiler ---

class ErrorCategory(str, Enum):
    SYNTAX = "syntax"
    TACTIC = "tactic"
    TYPE_MISMATCH = "type_mismatch"
    MISSING_LEMMA = "missing_lemma"
    FUNDAMENTAL = "fundamental"
    UNKNOWN = "unknown"


class CompilerError(BaseModel):
    line: int | None = None
    column: int | None = None
    message: str
    category: ErrorCategory


class LeanCode(BaseModel):
    code: str
    imports: list[str] = Field(default_factory=list)


# --- Agent 5: Proof Structurer ---

class StructuredProof(BaseModel):
    theorem_name: str
    strategy: ProofStrategy
    goal_statement: str
    assumptions: list[Assumption] = Field(default_factory=list)
    dependencies: list[Dependency] = Field(default_factory=list)
    steps: list[ProofStep] = Field(default_factory=list)
    conclusion: str
