import Mathlib

variable (G : Type) [AddCommGroup G]

instance : NonUnitalRing G :=
  { (inferInstance : AddCommGroup G) with
    mul := fun _ _ => 0
    mul_assoc := by
      intro a b c
      rfl
    left_distrib := by
      intro a b c
      show (0 : G) = 0 + 0
      rw [add_zero]
    right_distrib := by
      intro a b c
      show (0 : G) = 0 + 0
      rw [add_zero]
    zero_mul := by
      intro a
      rfl
    mul_zero := by
      intro a
      rfl }