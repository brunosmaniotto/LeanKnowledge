import Mathlib

noncomputable def marginalRateOfSubstitution
    {L : ℕ} (u : (Fin L → ℝ) → ℝ) (x : Fin L → ℝ) (ℓ k : Fin L) : ℝ :=
  (fderiv ℝ u x (Pi.single ℓ 1)) / (fderiv ℝ u x (Pi.single k 1))