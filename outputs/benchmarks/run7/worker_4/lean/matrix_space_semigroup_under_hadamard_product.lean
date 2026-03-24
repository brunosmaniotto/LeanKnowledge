import Mathlib

variable {m n S : Type*}

instance [Semigroup S] : Semigroup (Matrix m n S) where
  mul A B i j := A i j * B i j
  mul_assoc A B C := by
    ext i j
    exact mul_assoc (A i j) (B i j) (C i j)

instance [CommSemigroup S] : CommSemigroup (Matrix m n S) where
  mul_comm A B := by
    ext i j
    exact mul_comm (A i j) (B i j)

instance [Monoid S] : Monoid (Matrix m n S) where
  one i j := 1
  one_mul A := by
    ext i j
    exact one_mul (A i j)
  mul_one A := by
    ext i j
    exact mul_one (A i j)