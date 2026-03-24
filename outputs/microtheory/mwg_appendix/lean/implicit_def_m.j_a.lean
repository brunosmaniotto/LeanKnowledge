import Mathlib

/-- A vector x̄ ∈ ℝᴺ is a critical point of f if all partial derivatives vanish at x̄. -/
noncomputable def MWG.IsCriticalPoint {N : ℕ} (f : (Fin N → ℝ) → ℝ) (x : Fin N → ℝ) : Prop :=
  ∀ i : Fin N, deriv (fun t => f (Function.update x i t)) (x i) = 0