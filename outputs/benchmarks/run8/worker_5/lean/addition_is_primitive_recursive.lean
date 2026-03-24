import Mathlib

open Primrec

theorem Addition_is_Primitive_Recursive : Primrec₂ Nat.add :=
  nat_add