import Mathlib

def IsHomogeneous (N : ℕ) (f : (Fin N → ℝ) → ℝ) (r : ℝ) : Prop :=
  ∀ (t : ℝ), t > 0 → ∀ (x : Fin N → ℝ), f (t • x) = t ^ r * f x