import Mathlib

theorem homogeneous_zero_condition (f : ℝ → ℝ → ℝ) (h : ∀ t x y, f (t * x) (t * y) = f x y) (x : ℝ) (hx : x ≠ 0) (y : ℝ) :
    f x y = f 1 (y / x) := by
  rw [← h (1 / x) x y]
  have h1 : (1 / x) * x = (1 : ℝ) := by field_simp [hx]
  have h2 : (1 / x) * y = y / x := by field_simp
  rw [h1, h2]