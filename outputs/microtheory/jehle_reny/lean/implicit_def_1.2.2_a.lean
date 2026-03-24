import Mathlib

/-- The marginal utility of good `i`: the partial derivative ∂u(x)/∂xᵢ. -/
noncomputable def marginalUtility
    {L : ℕ} (u : (Fin L → ℝ) → ℝ) (x : Fin L → ℝ) (i : Fin L) : ℝ :=
  fderiv ℝ u x (Pi.single i 1)