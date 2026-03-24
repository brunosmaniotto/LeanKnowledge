import Mathlib

-- Game from MWG Figure 8.B.3
-- Player 1 strategies: U, D; Player 2 strategies: L, M, R
-- We demonstrate that iterated deletion of weakly dominated strategies
-- can depend on order by showing two valid deletion sequences yield different outcomes.

inductive Row : Type where | U | D deriving DecidableEq, Fintype
inductive Col : Type where | L | M | R deriving DecidableEq, Fintype

open Row Col

-- Payoff matrices (player 1, player 2)
def u1 : Row → Col → ℤ
  | U, L => 3 | U, M => 0 | U, R => 0
  | D, L => 2 | D, M => 1 | D, R => 1