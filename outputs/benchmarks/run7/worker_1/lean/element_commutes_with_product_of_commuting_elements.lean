import Mathlib.Algebra.Group.Basic

variable {S : Type*} [Semigroup S] (x y z : S)

theorem commutes_with_product (hxy : x * y = y * x) (hxz : x * z = z * x) : x * (y * z) = (y * z) * x := by
  calc
    x * (y * z) = (x * y) * z := by rw [mul_assoc]
    _ = (y * x) * z := by rw [hxy]
    _ = y * (x * z) := by rw [mul_assoc]
    _ = y * (z * x) := by rw [hxz]
    _ = (y * z) * x := by rw [mul_assoc]