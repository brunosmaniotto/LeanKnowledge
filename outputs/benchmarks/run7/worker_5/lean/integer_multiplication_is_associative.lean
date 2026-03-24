import Mathlib

theorem integer_multiplication_is_associative (x y z : ℤ) : x * (y * z) = (x * y) * z :=
  (Int.mul_assoc x y z).symm