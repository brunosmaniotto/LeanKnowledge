import Mathlib
open Finset BigOperators
open Nat

-- Define strategies for Player 1 (U, C, D) and Player 2 (L, M, R)
inductive P1Strat : Type
  | U : P1Strat
  | C : P1Strat
  | D : P1Strat
  deriving DecidableEq, Fintype, Repr

inductive P2Strat : Type
  | L : P2Strat
  | M : P2Strat
  | R : P2Strat
  deriving DecidableEq, Fintype, Repr

open P1Strat P2Strat

-- Define the payoff matrix for Player 1 (Row Player)
-- Values inferred from the problem description and proof sketch.
def p1_payoff : P1Strat → P2Strat → ℤ
  | U, L => 3  -- (U, L) payoff (3, 0) in reduced game
  | U, M => 2  -- D is best for P1 against M (4 > 2)
  | U, R => 0  -- U is best for P1 against R (0 > -1 > -2)
  | C, L => 1  -- C is dominated by D (2 > 1)
  | C, M => 3  -- C is dominated by D (4 > 3)
  | C, R => -2 -- C is dominated by D (-1 > -2)
  | D, L => 2  -- D dominates C (2 > 1)
  | D, M => 4  -- D dominates C (4 > 3)
  | D, R => -1 -- D dominates C (-1 > -2)

-- Define the payoff matrix for Player 2 (Column Player)
-- Values inferred from the problem description and proof sketch.