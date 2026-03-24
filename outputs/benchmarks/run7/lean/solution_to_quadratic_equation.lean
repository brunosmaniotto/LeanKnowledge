import Mathlib

theorem quadratic_formula (a b c x : ℝ) (ha : a ≠ 0) (h : a * x ^ 2 + b * x + c = 0) :
    x = (-b + Real.sqrt (b ^ 2 - 4 * a * c)) / (2 * a) ∨
    x = (-b - Real.sqrt (b ^ 2 - 4 * a * c)) / (2 * a) := by
  have h1 : (2 * a * x + b) ^ 2 = b ^ 2 - 4 * a * c := by
    calc
      (2 * a * x + b) ^ 2 = 4 * a * (a * x ^ 2 + b * x + c) + (b ^ 2 - 4 * a * c) := by ring
      _ = 4 * a * 0 + (b ^ 2 - 4 * a * c) := by rw [h]
      _ = b ^ 2 - 4 * a * c := by ring

  have h_nonneg : 0 ≤ b ^ 2 - 4 * a * c := by
    linarith [sq_nonneg (2 * a * x + b)]

  have h2 : (2 * a * x + b - Real.sqrt (b ^ 2 - 4 * a * c)) *
            (2 * a * x + b + Real.sqrt (b ^ 2 - 4 * a * c)) = 0 := by
    calc
      (2 * a * x + b - Real.sqrt (b ^ 2 - 4 * a * c)) * (2 * a * x + b + Real.sqrt (b ^ 2 - 4 * a * c)) =
          (2 * a * x + b) ^ 2 - (Real.sqrt (b ^ 2 - 4 * a * c)) ^ 2 := by ring
      _ = (b ^ 2 - 4 * a * c) - (Real.sqrt (b ^ 2 - 4 * a * c)) ^ 2 := by rw [h1]
      _ = (b ^ 2 - 4 * a * c) - (b ^ 2 - 4 * a * c) := by rw [Real.sq_sqrt h_nonneg]
      _ = 0 := by ring

  rcases eq_zero_or_eq_zero_of_mul_eq_zero h2 with (h3 | h3)
  · left
    field_simp [ha]
    linarith
  · right
    field_simp [ha]
    linarith