import Mathlib
open Nat

def L : ℕ → ℕ
| 0 => 1
| n+1 => L n + (n+1)