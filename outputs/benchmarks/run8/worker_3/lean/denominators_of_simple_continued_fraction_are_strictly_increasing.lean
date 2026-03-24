import Mathlib

def denominators (a : ℕ → ℤ) : ℕ → ℤ
  | 0 => 1
  | 1 => a 1
  | n+2 => a (n+2) * denominators a (n+1) + denominators a n