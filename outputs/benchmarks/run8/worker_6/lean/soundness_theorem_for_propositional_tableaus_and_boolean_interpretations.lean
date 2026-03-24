import Mathlib

-- We formalize the components of the logical system abstractly.
-- This allows the proof to be general and not tied to a specific
-- implementation of formulas or tableau rules.

-- Use a section to manage the scope of variables.
section SoundnessProof

-- A type for well-formed formulas (WFFs).
variable (Formula : Type)

-- A predicate for tableau provability.
-- `TableauProof H A` means "A is provable from the set of hypotheses H".
variable (TableauProof : Set Formula → Formula → Prop)

-- A predicate for semantic consequence in boolean interpretations.
-- `BooleanModels H A` means "A is a semantic consequence of the set of hypotheses H".
variable (BooleanModels : Set Formula → Formula → Prop)

-- We assume the Extended Soundness Theorem as an axiom.
-- This theorem states that for any *countable* set of hypotheses H,
-- if a formula A is provable from H, then it is