import Mathlib
open Topology

-- Define player 1's strategies
inductive P1Strat : Type
  | U : P1Strat
  | D : P1Strat
  deriving DecidableEq, Repr, Inhabited

-- Define player 2's strategies
inductive P2Strat : Type
  | L : P2Strat
  | R : P2Strat
  deriving DecidableEq, Repr, Inhabited

-- Payoff for Player 1
def u1 (p1 : P1Strat) (p2 : P2Strat) : ℤ :=
  match p1, p2 with
  | .U, .L => 3
  | .U, .R => 0
  | .D, .L => 2
  | .D, .R => -1

-- Payoff for Player 2