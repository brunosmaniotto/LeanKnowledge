import Mathlib.Computability.Primrec

open Primrec

def is_zero : ℕ → ℕ
  | 0 => 1
  | _ + 1 => 0