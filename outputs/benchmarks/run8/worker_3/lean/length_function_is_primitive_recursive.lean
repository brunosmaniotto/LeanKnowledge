import Mathlib.Computability.Primrec
open Primrec

-- Divisibility characteristic function (1 if m divides n, 0 otherwise)
def div_char (n m : ℕ) : ℕ :=
  if m ∣ n then 1 else 0