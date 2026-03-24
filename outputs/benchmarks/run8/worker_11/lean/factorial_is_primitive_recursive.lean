import Mathlib.Computability.Primrec

def fac : ℕ → ℕ
  | 0 => 1
  | n + 1 => (n + 1) * fac n