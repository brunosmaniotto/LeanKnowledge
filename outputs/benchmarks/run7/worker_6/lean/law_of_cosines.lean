import Mathlib
open Real

theorem law_of_cosines (a b C : ℝ) : (b * cos C - a) ^ 2 + (b * sin C) ^ 2 = a ^ 2 + b ^ 2 - 2 * a * b * cos C := by
  calc
    (b * cos C - a) ^ 2 + (b * sin C) ^ 2
        = (b * cos C) ^ 2 - 2 * a * (b * cos C) + a ^ 2 + (b * sin C) ^ 2 := by ring
    _ = b ^ 2 * cos C ^ 2 - 2 * a * b * cos C + a ^ 2 + b ^ 2 * sin C ^ 2 := by ring
    _ = a ^ 2 + b ^ 2 * cos C ^ 2 + b ^ 2 * sin C ^ 2 - 2 * a * b * cos C := by ring
    _ = a ^ 2 + b ^ 2 * (cos C ^ 2 + sin C ^ 2) - 2 * a * b * cos C := by ring
    _ = a ^ 2 + b ^ 2 * 1 - 2 * a * b * cos C := by rw [Real.cos_sq_add_sin_sq C]
    _ = a ^ 2 + b ^ 2 - 2 * a * b * cos C := by ring