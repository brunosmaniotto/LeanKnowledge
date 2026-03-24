import Mathlib

theorem idempotent_of_right_inverse {S : Type} [Semigroup S] (e_R : S)
    (h_right_id : ∀ y : S, y * e_R = y) (x x_R : S) (h_inv : x * x_R = e_R) :
    (x_R * x) * (x_R * x) = x_R * x := by
  calc
    (x_R * x) * (x_R * x) = x_R * (x * (x_R * x)) := by rw [mul_assoc x_R x (x_R * x)]
    _ = x_R * ((x * x_R) * x) := by rw [← mul_assoc x x_R x]
    _ = x_R * (e_R * x) := by rw [h_inv]
    _ = (x_R * e_R) * x := by rw [← mul_assoc]
    _ = x_R * x := by rw [h_right_id x_R]