import Mathlib

open Nat

-- Define the function for the next maximum strategy, ensuring it doesn't go below 1
def next_max_strat (m : ℕ) : ℕ := max 1 (m / 3)