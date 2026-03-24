import Mathlib

/-- A social welfare functional F satisfies the (weak) Pareto property if:
    1. Unanimous weak preference implies social weak preference.
    2. Unanimous strict preference implies strict social preference.
    F maps a profile of utility functions to a weak preference relation on X.
    The strict part is derived as: x strictly preferred to y iff x ≽ y and ¬(y ≽ x). -/
structure IsParetian {X : Type*} {I : Type*}
    (F : (I → X → ℝ) → X → X → Prop) : Prop where
  weak_pareto : ∀ (profile : I → X → ℝ) (x y : X),
    (∀ i : I, profile i x ≥ profile i y) → F profile x y
  strict_pareto : ∀ (profile : I → X → ℝ) (x y : X),
    (∀ i : I, profile i x > profile i y) → F profile x y ∧ ¬ F profile y x