import Mathlib

open Finset

-- Define the allowed moves in the take-away game
def moves_set : Finset ℕ := {1, 2, 3}

-- Mutually inductive definition of winning and losing positions
-- A position is losing if all possible moves lead to winning positions for the opponent.
-- A position is winning if there exists at least one move that leads to a losing position for the opponent.
mutual
  inductive is_losing_position : ℕ → Prop
    | zero_is_losing : is_losing_position 0
    | all_next_winning (k : ℕ) (h_k_pos : k > 0)
        (h_all_next_winning : ∀ m ∈ moves_set, k ≥ m → is_winning_position (k - m)) :
        is_losing_position k

  inductive is_winning_position : ℕ → Prop
    | exists_next_losing (k : ℕ) (m : ℕ) (h_m_mem : m ∈ moves_set) (h_k_ge_m : k ≥ m)
        (h_next_losing : is_losing_position (k - m)) :
        is_winning_position k
end