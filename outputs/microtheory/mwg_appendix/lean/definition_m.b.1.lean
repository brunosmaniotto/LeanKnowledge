import Mathlib

def IsHomogeneous {N : ℕ} (f : (Fin N → ℝ) → ℝ) (r : ℤ) : Prop :=
  ∀ (t : ℝ), t > 0 → ∀ (x : Fin N → ℝ),
    f (fun i => t * x i) = t ^ r * f x