import Mathlib

open Finset Nat

/-- A position `k` is a winning position if the current player
    can make a move `m` from `{1, 2, 3}` such that `k - m = 1`. -/
def is_winning (k : ℕ) : Prop :=
  ∃ m ∈ ({1, 2, 3} : Finset ℕ), k - m = 1