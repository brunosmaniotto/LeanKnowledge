import Mathlib

open Real

theorem cos_sq_add_sin_sq (x : ℝ) : cos x ^ 2 + sin x ^ 2 = 1 := by
  calc
    cos x ^ 2 + sin x ^ 2 = cos x * cos x + sin x * sin x := by ring
    _ = cos (x - x) := by rw [cos_sub]
    _ = cos 0 := by rw [sub_self]
    _ = 1 := by rw [cos_zero]