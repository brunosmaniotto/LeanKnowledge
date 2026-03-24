import Mathlib

theorem quadratic_formula (a b c x : ℝ) (ha : a ≠ 0) (h : a * x ^ 2 + b * x + c = 0) :
    x = (-b + Real.sqrt (b ^ 2 - 4 * a * c)) / (2 * a) ∨ x = (-b - Real.sqrt (b ^ 2 - 4 * a * c)) / (2 * a) := by
  have h1 : (2 * a * x + b) ^ 2 = b ^ 2 - 4 * a * c := by
    calc
      (2 * a * x + b) ^ 2 = 4 * a * (a * x ^ 2 + b * x + c) + (b ^ 2 - 4 * a * c) := by ring
      _ = 4 * a * 0 + (b ^ 2 - 4 * a * c) := by rw [h]
      _ = b ^ 2 - 4 * a * c := by ring

  have h2 : 0 ≤ b ^ 2 - 4 * a * c := by
    rw [← h1]
    apply pow_two_nonneg

  have h3 : |2 * a * x + b| = Real.sqrt (b ^ 2 - 4 * a * c) := by
    rw [← Real.sqrt_sq_eq_abs (2 * a * x + b), h1]

  have den_ne_zero : 2 * a ≠ 0 := mul_ne_zero (by norm_num) ha

  by_cases hle : 2 * a * x + b ≤ 0
  · rw [abs_of_nonpos hle] at h3
    right
    field_simp [den_ne_zero]
    linarith
  · have hge : 0 ≤ 2 * a * x + b := by linarith
    rw [abs_of_nonneg hge] at h3
    left
    field_simp [den_ne_zero]
    linarith