import Mathlib.Data.Set.Basic
import Mathlib.Tactic.TFAE

open Set

variable {α : Type*}

/-- The inverse of a relation represented as a set of pairs. -/
def inv (R : Set (α × α)) : Set (α × α) := {p | (p.2, p.1) ∈ R}

notation:max R "⁻¹" => inv R