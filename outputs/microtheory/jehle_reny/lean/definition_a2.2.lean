import Mathlib

def IsHomogeneousOfDegree {N : ℕ} (f : (Fin N → ℝ) → ℝ) (k : ℤ) : Prop :=
  ∀ (t : ℝ), t > 0 → ∀ (x : Fin N → ℝ), f (t • x) = t ^ k * f x