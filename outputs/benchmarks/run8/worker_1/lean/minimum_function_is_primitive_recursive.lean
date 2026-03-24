import Mathlib

open Primrec

theorem Minimum_Function_is_Primitive_Recursive : Primrec₂ (min : ℕ → ℕ → ℕ) :=
  nat_min