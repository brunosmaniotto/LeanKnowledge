import Mathlib

/-- Two sets are equal if and only if each is a subset of the other.
    This is the standard set-equality characterization: S = T ↔ S ⊆ T ∧ T ⊆ S. -/
abbrev MWG.SetsEqual {α : Type*} (S T : Set α) : Prop :=
  S ⊆ T ∧ T ⊆ S