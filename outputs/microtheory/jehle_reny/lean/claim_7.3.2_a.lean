import Mathlib

-- In misere play, a position is losing if any valid move forces the player to take the last coin, leaving zero.
def IsLosingPosition (k : ℕ) (S : Set ℕ) := ∀ m ∈ S, m ≤ k → k - m = 0

-- Assume sub-lemmas are available as axioms for assembly
axiom unique_move_from_one {S : Set ℕ} (h_moves_are_positive : ∀ m ∈ S, 0 < m) {m : ℕ} (hm_in_S : m ∈ S) (hm_le_one : m ≤ 1) : m = 1
axiom taking_one_from_one_leaves_zero : 1 - 1 = 0