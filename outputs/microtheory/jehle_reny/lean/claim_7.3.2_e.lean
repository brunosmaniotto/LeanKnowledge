import Mathlib

open Nat

-- Define the set of allowed moves (removing 1, 2, or 3 coins).
def allowedMoves : Set ℕ := {1, 2, 3}

-- A position `k` is a P-position (previous player winning, current player losing)
-- if all moves from `k` lead to N-positions.
-- A position `k` is an N-position (next player winning, current player winning)
-- if there exists a move from `k` to a P-position.
-- The terminal position (0 coins) is a P-position (the player whose turn it is loses).

-- We define `is_p_position k` as `k % 4 = 0` for this game.
-- This is because if `k % 4 = 0`, any move `k - m` where `m ∈ {1,2,3}`
-- will result in `(k - m) % 4 ∈ {1,2,3}`. These are N-positions.
-- If `k % 4 ∈ {1,2,3}`, then a move `m` can be chosen such that `k - m`
-- is a multiple of 4, thus leading to a P-position.