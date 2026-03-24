import Mathlib

open Real

variable (m : ℝ)

def U : ℕ → ℝ
  | 0 => 0
  | 1 => 1
  | n+2 => m * U (n+1) + U n