import Mathlib

def IsConcaveFn (D : Set ℝ) (f : ℝ → ℝ) : Prop :=
  ∀ x ∈ D, ∀ y ∈ D, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
    f (t * x + (1 - t) * y) ≥ t * f x + (1 - t) * f y