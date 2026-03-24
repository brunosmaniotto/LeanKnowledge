import Mathlib

variable {M : Type*} [Monoid M]

theorem invertible_implies_cancellable {a : M} (h : ∃ b, b * a = 1 ∧ a * b = 1) :
    (∀ x y, a * x = a * y → x = y) ∧ (∀ x y, x * a = y * a → x = y) := by
  rcases h with ⟨b, h_left_inv, h_right_inv⟩
  constructor
  · intro x y h_eq
    calc
      x = 1 * x := by rw [one_mul]
      _ = (b * a) * x := by rw [h_left_inv]
      _ = b * (a * x) := by rw [mul_assoc]
      _ = b * (a * y) := by rw [h_eq]
      _ = (b * a) * y := by rw [mul_assoc]
      _ = 1 * y := by rw [h_left_inv]
      _ = y := by rw [one_mul]
  · intro x y h_eq
    calc
      x = x * 1 := by rw [mul_one]
      _ = x * (a * b) := by rw [h_right_inv]
      _ = (x * a) * b := by rw [mul_assoc]
      _ = (y * a) * b := by rw [h_eq]
      _ = y * (a * b) := by rw [mul_assoc]
      _ = y * 1 := by rw [h_right_inv]
      _ = y := by rw [mul_one]