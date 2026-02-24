from typing import Literal
from pydantic import BaseModel, Field
from enum import Enum
from datetime import datetime


# --- Stage 0: Extraction Agent I/O ---

class StatementType(str, Enum):
    DEFINITION = "definition"
    AXIOM = "axiom"
    PROPOSITION = "proposition"
    THEOREM = "theorem"
    LEMMA = "lemma"
    COROLLARY = "corollary"
    EXAMPLE = "example"
    REMARK = "remark"
    CLAIM = "claim"  # unlabeled mathematical claim found in prose
    INVOKED_DEPENDENCY = "invoked_dependency"
    IMPLICIT_ASSUMPTION = "implicit_assumption"


class ClaimRole(str, Enum):
    DEFINITION = "definition"
    CLAIMED_RESULT = "claimed_result"
    INVOKED_DEPENDENCY = "invoked_dependency"
    IMPLICIT_ASSUMPTION = "implicit_assumption"


class ExtractedItem(BaseModel):
    id: str  # e.g. "Proposition 1.B.1" or "Claim 1.B.a" for inline claims
    type: StatementType
    role: ClaimRole = ClaimRole.CLAIMED_RESULT
    statement: str
    proof: str | None = None  # definitions/axioms don't have proofs
    proof_sketch: str | None = None  # for inline justifications ("it follows that...")
    dependencies: list[str] = Field(default_factory=list)  # references to other items
    section: str  # e.g. "1.B Preference and Choice"
    labeled: bool = True  # False if extracted from running prose (no formal label in text)
    context: str | None = None  # surrounding text needed to understand the statement
    notation_in_scope: dict[str, str] = Field(default_factory=dict)


class ExtractionResult(BaseModel):
    source: str  # e.g. "MWG Chapter 1"
    items: list[ExtractedItem]


class Domain(str, Enum):
    REAL_ANALYSIS = "real_analysis"
    TOPOLOGY = "topology"
    ALGEBRA = "algebra"
    MEASURE_THEORY = "measure_theory"
    MICROECONOMICS = "microeconomics"
    GAME_THEORY = "game_theory"
    WELFARE_ECONOMICS = "welfare_economics"
    NUMBER_THEORY = "number_theory"
    COMBINATORICS = "combinatorics"
    SET_THEORY = "set_theory"
    LOGIC = "logic"
    GEOMETRY = "geometry"
    PROBABILITY = "probability"
    ORDER_THEORY = "order_theory"


class ProofStrategy(str, Enum):
    DIRECT = "direct"
    CONTRADICTION = "contradiction"
    INDUCTION = "induction"
    CONSTRUCTION = "construction"
    CASES = "cases"


class ErrorCategory(str, Enum):
    SYNTAX = "syntax"
    TACTIC = "tactic"
    TYPE_MISMATCH = "type_mismatch"
    MISSING_LEMMA = "missing_lemma"
    FUNDAMENTAL = "fundamental"
    UNKNOWN = "unknown"


# --- Stage 1: Proof Agent I/O ---

class TheoremInput(BaseModel):
    name: str
    statement: str
    domain: Domain
    source: str | None = None  # e.g. "MWG Proposition 3.D.2"


class ProofStep(BaseModel):
    description: str
    justification: str  # e.g. "by the triangle inequality"


class StructuredProof(BaseModel):
    theorem_name: str
    strategy: ProofStrategy
    assumptions: list[str]
    dependencies: list[str]  # named lemmas/theorems used
    steps: list[ProofStep]
    conclusion: str


# --- Stage 2: Translator I/O ---

class LeanCode(BaseModel):
    code: str
    imports: list[str] = Field(default_factory=list)


# --- Stage 3: Verifier I/O ---

class CompilerError(BaseModel):
    line: int | None = None
    column: int | None = None
    message: str
    category: ErrorCategory


class VerificationResult(BaseModel):
    success: bool
    lean_code: str
    errors: list[CompilerError] = Field(default_factory=list)
    iterations: int
    escalated_to_proof_agent: bool = False


# --- Stage 4: Knowledge Agent I/O ---

class KnowledgeNode(BaseModel):
    theorem_name: str
    domain: Domain
    tags: list[str]  # method tags: "epsilon_delta", "fixed_point", etc.
    lean_dependencies: list[str]  # extracted from Lean imports/invocations
    semantic_connections: list[str]  # cross-domain links
    notes: str | None = None
    is_conditional: bool = False  # True if depends on unresolved backlog items


class LibrarianResult(BaseModel):
    query: str
    found: bool
    lean_name: str | None = None
    import_path: str | None = None
    type_signature: str | None = None
    confidence: Literal["high", "medium", "low"] = "medium"
    notes: str | None = None


# --- Rosetta Stone ---

class RosettaPair(BaseModel):
    id: str
    source: Literal["mathlib", "pipeline", "proofwiki"]
    mathlib_module: str | None = None
    mathlib_name: str | None = None
    lean_code: str
    nl_proof: StructuredProof
    metadata: dict = Field(default_factory=dict)
    confidence: Literal["high", "medium", "low"] = "medium"


# --- Pipeline-level ---

class ResolverResult(BaseModel):
    success: bool
    item_id: str
    lean_code: str  # the proved theorem code (or last failed attempt)
    iterations: int
    proof_revisions: int
    errors: list[CompilerError] = Field(default_factory=list)


class PipelineResult(BaseModel):
    success: bool
    theorem: TheoremInput
    proof: StructuredProof | None = None
    verification: VerificationResult | None = None
    knowledge: KnowledgeNode | None = None


class TrainingPair(BaseModel):
    theorem: TheoremInput
    nl_proof: StructuredProof
    lean_code: str
    timestamp: datetime = Field(default_factory=datetime.now)
    iterations_needed: int


# --- Backlog ---

class BacklogStatus(str, Enum):
    PENDING = "pending"        # extracted, dependencies not yet checked
    BLOCKED = "blocked"        # waiting on unresolved dependencies
    READY = "ready"            # all dependencies resolved, can be formalized
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"    # successfully formalized and verified
    FAILED = "failed"          # formalization attempted, did not succeed
    SKIPPED = "skipped"        # definitions/axioms — tracked but don't need proving
    AXIOMATIZED = "axiomatized"  # formalization failed, accepted as axiom


class BacklogEntry(BaseModel):
    item: ExtractedItem
    source: str
    domain: Domain
    status: BacklogStatus = BacklogStatus.PENDING
    category: Literal["referenced", "unreferenced", "omitted_proof"] = "unreferenced"
    lean_file: str | None = None       # path to verified .lean output
    failure_reason: str | None = None
    attempts: int = 0
    priority_score: int = 0            # calculated: count of downstream dependents
    added_at: datetime = Field(default_factory=datetime.now)
    completed_at: datetime | None = None
