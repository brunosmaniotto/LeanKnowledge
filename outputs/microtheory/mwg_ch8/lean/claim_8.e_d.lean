import Mathlib

open Real

theorem alphabeta_cutoff_weakly_above
    (c : ℝ) (p : ℝ) (hc : 0 ≤ c) (hp0 : 0 ≤ p) (hp1 : p < 1) :
    Real.sqrt c ≤ Real.sqrt (c / (1 - p)) := by
  apply Real.sqrt_le_sqrt
  have h1 : (0 : ℝ) < 1 - p := by linarith
  rw [le_div_iff₀ h1]
  nlinarith