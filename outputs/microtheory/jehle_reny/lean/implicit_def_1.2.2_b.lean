import Mathlib

noncomputable def marginalRateOfSubstitution
    {L : ℕ} (u : (Fin L → ℝ) → ℝ) (x : Fin L → ℝ) (i j : Fin L) : ℝ :=
  (fderiv ℝ u x (Pi.single i 1)) / (fderiv ℝ u x (Pi.single j 1))