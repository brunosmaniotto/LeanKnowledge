import Mathlib

open Int

def altSum : List ℕ → ℤ
  | [] => 0
  | d::ds => (d : ℤ) - altSum ds