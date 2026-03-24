import Mathlib

open Function

variable [Mul S] [Mul T]

theorem equiv_preserves_mul_iff_symm_preserves_mul (e : S ≃ T) :
    (∀ a b, e (a * b) = e a * e b) ↔ (∀ x y, e.symm (x * y) = e.symm x * e.symm y) := by
  constructor
  · intro h x y
    calc
      e.symm (x * y) = e.symm (e (e.symm x) * e (e.symm y)) := by rw [e.apply_symm_apply, e.apply_symm_apply]
      _ = e.symm (e (e.symm x * e.symm y)) := by rw [h]
      _ = e.symm x * e.symm y := by rw [e.symm_apply_apply]
  · intro h a b
    calc
      e (a * b) = e (e.symm (e a) * e.symm (e b)) := by rw [e.symm_apply_apply, e.symm_apply_apply]
      _ = e (e.symm (e a * e b)) := by rw [h]
      _ = e a * e b := by rw [e.apply_symm_apply]