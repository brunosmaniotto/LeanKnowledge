import Mathlib

/-- A utility function `u : X → ℝ` represents a preference relation `≿` if
    for all `x, y ∈ X`, `x ≿ y ↔ u x ≥ u y`. -/
def IsUtilityFor {X : Type*} (u : X → ℝ) (pref : X → X → Prop) : Prop :=
  ∀ x y, pref x y ↔ u x ≥ u y