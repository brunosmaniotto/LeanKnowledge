import Mathlib

variable {S : Type} [Monoid S]

theorem left_inverse_eq_right_inverse_and_unique (x xL xR : S) (hL : xL * x = 1) (hR : x * xR = 1) :
    xL = xR ∧ ∀ y, (y * x = 1 ∧ x * y = 1) → y = xL := by
  have h_eq : xL = xR := by
    calc
      xL = xL * 1 := by rw [mul_one]
      _ = xL * (x * xR) := by rw [hR]
      _ = (xL * x) * xR := by rw [mul_assoc]
      _ = 1 * xR := by rw [hL]
      _ = xR := by rw [one_mul]
  refine ⟨h_eq, ?_⟩
  intro y ⟨hyL, hyR⟩
  calc
    y = y * 1 := by rw [mul_one]
    _ = y * (x * xR) := by rw [hR]
    _ = (y * x) * xR := by rw [mul_assoc]
    _ = 1 * xR := by rw [hyL]
    _ = xR := by rw [one_mul]
    _ = xL := by rw [h_eq]