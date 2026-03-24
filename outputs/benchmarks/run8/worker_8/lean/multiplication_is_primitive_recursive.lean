import Mathlib

theorem Multiplication_is_Primitive_Recursive : Primrec₂ fun (n m : ℕ) => n * m :=
  Primrec.nat_mul