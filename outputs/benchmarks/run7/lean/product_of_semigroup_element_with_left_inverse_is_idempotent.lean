import Mathlib

theorem product_of_semigroup_element_with_left_inverse_is_idempotent {S : Type} [Semigroup S]
  (e_L : S) (left_identity : ∀ a : S, e_L * a = a) (x : S) (x_L : S) (h_inv : x_L * x = e_L) :
  (x * x_L) * (x * x_L) = x * x_L := by
  calc
    (x * x_L) * (x * x_L) = ((x * x_L) * x) * x_L := by rw [← mul_assoc]
    _ = (x * (x_L * x)) * x_L := by rw [mul_assoc x x_L x]
    _ = (x * e_L) * x_L := by rw [h_inv]
    _ = x * (e_L * x_L) := by rw [mul_assoc]
    _ = x * x_L := by rw [left_identity x_L]