import Mathlib

/--
The operation of complex conjugation is a field automorphism of the complex numbers.
This is represented as a ring equivalence from `ℂ` to itself.
-/
noncomputable def Complex_Conjugation_is_Automorphism : ℂ ≃+* ℂ where
  toFun      := star
  invFun     := star
  left_inv   := star_star
  right_inv  := star_star
  map_add'   := star_add
  map_mul'   := fun x y => by rw [star_mul, mul_comm]