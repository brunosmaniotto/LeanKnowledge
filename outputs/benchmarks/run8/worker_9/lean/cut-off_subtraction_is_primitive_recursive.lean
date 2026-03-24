import Mathlib

theorem Cut_Off_Subtraction_is_Primitive_Recursive : Primrec₂ (fun (n m : ℕ) => n - m) :=
  Primrec.nat_sub