import Mathlib

theorem ellsberg_paradox_inconsistency
    (p : ℝ)
    (hp0 : 0 ≤ p) (hp1 : p ≤ 1)
    (h_prefer_R_black : (51 : ℝ) / 100 > 1 - p)
    (h_prefer_R_white : (49 : ℝ) / 100 > p) :
    False := by
  linarith