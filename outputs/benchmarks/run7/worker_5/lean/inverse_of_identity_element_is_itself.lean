import Mathlib

theorem inverse_of_identity_eq_self {S : Type} [MulOneClass S] (e_inv : S) (h : (1 : S) * e_inv = 1) : e_inv = 1 := by
  calc
    e_inv = 1 * e_inv := by rw [one_mul]
    _ = 1 := by rw [h]