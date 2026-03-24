import Mathlib

open Set

def IsPeak (x : ℕ → ℝ) (n : ℕ) : Prop := ∀ m, n < m → x m ≤ x n