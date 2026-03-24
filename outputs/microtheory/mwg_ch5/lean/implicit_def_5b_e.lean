import Mathlib

/-- The marginal rate of transformation of good ℓ for good k at production vector y_bar,
    defined as the ratio of partial derivatives ∂F/∂y_ℓ divided by ∂F/∂y_k. -/
noncomputable def MRT {L : ℕ} (F : (Fin L → ℝ) → ℝ) (y_bar : Fin L → ℝ) (l k : Fin L) : ℝ :=
  fderiv ℝ F y_bar (Pi.single l 1) / fderiv ℝ F y_bar (Pi.single k 1)