import Mathlib

theorem mitiushin_polterovich_homothetic
    (numerator denominator : ℝ)
    (h_num : numerator = 0)
    (h_denom : denominator ≠ 0) :
    numerator / denominator = 0 ∧ numerator / denominator < 4 := by
  subst h_num
  simp