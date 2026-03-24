import Mathlib

theorem zero_divisor_product {R : Type} [Ring R] {x : R} (h : ∃ y : R, y ≠ 0 ∧ x * y = 0) (z : R) :
    ∃ w : R, w ≠ 0 ∧ (z * x) * w = 0 := by
  rcases h with ⟨y, hy_ne_zero, hxy⟩
  refine ⟨y, hy_ne_zero, ?_⟩
  calc
    (z * x) * y = z * (x * y) := by rw [mul_assoc]
    _ = z * 0 := by rw [hxy]
    _ = 0 := by rw [mul_zero]