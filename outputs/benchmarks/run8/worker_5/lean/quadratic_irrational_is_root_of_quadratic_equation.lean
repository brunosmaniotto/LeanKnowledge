import Mathlib

open Real

theorem quadratic_irrat_is_root (r s : ℚ) (n : ℕ) :
    ∃ (a b c : ℚ), (a : ℝ) * (((r : ℝ) + (s : ℝ) * Real.sqrt (n : ℝ)) : ℝ) ^ 2 + (b : ℝ) * ((r : ℝ) + (s : ℝ) * Real.sqrt (n : ℝ)) + (c : ℝ) = 0 := by
  use 1, -2 * r, r ^ 2 - s ^ 2 * (n : ℚ)
  push_cast
  have h : (Real.sqrt (n : ℝ)) ^ 2 = (n : ℝ) := Real.sq_sqrt (Nat.cast_nonneg n)
  calc
    (1 : ℝ) * ((r : ℝ) + (s : ℝ) * Real.sqrt (n : ℝ)) ^ 2 + (-2 * (r : ℝ)) * ((r : ℝ) + (s : ℝ) * Real.sqrt (n : ℝ)) + ((r : ℝ) ^ 2 - (s : ℝ) ^ 2 * (n : ℝ)) =
        (s : ℝ) ^ 2 * ((Real.sqrt (n : ℝ)) ^ 2 - (n : ℝ)) := by ring
    _ = (s : ℝ) ^ 2 * 0 := by rw [h, sub_self]
    _ = 0 := by ring