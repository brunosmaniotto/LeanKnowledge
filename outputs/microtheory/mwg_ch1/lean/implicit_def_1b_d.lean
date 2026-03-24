import Mathlib

/-- A utility function representing a preference relation `pref` on `X`.
    `u` assigns a real value to each element such that `x ≿ y ↔ u(x) ≥ u(y)`. -/
structure UtilityFunction (X : Type*) (pref : X → X → Prop) where
  u : X → ℝ
  represents : ∀ x y : X, pref x y ↔ u x ≥ u y