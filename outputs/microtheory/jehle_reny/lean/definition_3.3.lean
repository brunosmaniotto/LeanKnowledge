import Mathlib

namespace MWG

def ConstantReturnsToScale {N : ℕ} (f : (Fin N → ℝ) → ℝ) : Prop :=
  ∀ t > 0, ∀ x : Fin N → ℝ, f (fun i => t * x i) = t * f x