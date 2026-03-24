import Mathlib

open Nat

def all_digits_odd (n : ℕ) : Prop := ∀ d ∈ digits 10 n, d % 2 = 1