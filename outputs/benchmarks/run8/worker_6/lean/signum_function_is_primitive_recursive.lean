import Mathlib.Computability.Primrec

open Primrec

def sgn : ℕ → ℕ := λ n => if n = 0 then 0 else 1