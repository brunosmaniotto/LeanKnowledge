import Mathlib

def IsHomogeneousDegOne {N : ℕ} (f : (Fin N → ℝ) → ℝ) : Prop :=
  ∀ (t : ℝ), t > 0 → ∀ (x : Fin N → ℝ), f (fun i => t * x i) = t * f x