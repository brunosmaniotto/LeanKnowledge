import Mathlib

/-- Definition 1.1 (Jehle & Reny): A preference relation on a consumption set `X`.
    The binary relation ≿ is a preference relation if it satisfies
    Axiom 1 (Completeness) and Axiom 2 (Transitivity). -/
structure PreferenceRelation (X : Type*) where
  /-- The weak preference relation ≿ : `pref x y` means "x is at least as good as y" -/
  pref : X → X → Prop
  /-- Axiom 1 (Completeness): For all x, y ∈ X, either x ≿ y or y ≿ x (or both). -/
  complete : ∀ x y : X, pref x y ∨ pref y x
  /-- Axiom 2 (Transitivity): For all x, y, z ∈ X, if x ≿ y and y ≿ z, then x ≿ z. -/
  transitive : ∀ x y z : X, pref x y → pref y z → pref x z