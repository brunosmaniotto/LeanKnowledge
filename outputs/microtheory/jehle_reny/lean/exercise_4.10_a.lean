import Mathlib

theorem Exercise_4_10_a
    (a b c : ℝ)
    (hb : 0 < b)
    (hac : c < a) :
    (a - c) ^ 2 / (8 * b) > (a - c) ^ 2 / (9 * b) ∧
    (a - c) ^ 2 / (16 * b) < (a - c) ^ 2 / (9 * b) := by
  have hac' : 0 < a - c := by linarith
  have hac2 : 0 < (a - c) ^ 2 := by positivity
  have hb8 : (8 : ℝ) * b ≠ 0 := by positivity
  have hb9 : (9 : ℝ) * b ≠ 0 := by positivity
  have hb16 : (16 : ℝ) * b ≠ 0 := by positivity
  constructor
  · rw [gt_iff_lt]
    rw [div_lt_div_iff₀ (by positivity : 0 < 9 * b) (by positivity : 0 < 8 * b)]
    nlinarith
  · rw [div_lt_div_iff₀ (by positivity : 0 < 16 * b) (by positivity : 0 < 9 * b)]
    nlinarith