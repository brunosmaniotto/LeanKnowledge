import Mathlib
open Topology

-- Two players in the game.
inductive Player | p1 | p2
  deriving DecidableEq, Fintype

-- Player 1's possible actions.
inductive P1Action | L | R
  deriving DecidableEq, Fintype

-- Player 2's possible actions.
inductive P2Action | l | r
  deriving DecidableEq, Fintype

-- Payoff function for the coordination game. Payoffs are symmetric.
-- A player gets 2 if actions are coordinated ((L,l) or (R,r)) and 0 otherwise.
def payoff (a1 : P1Action) (a2 : P2Action) : ℤ :=
  match a1, a2 with
  | .L, .l => 2
  | .R, .r => 2
  | _, _ => 0

-- An action for P2 is "unconditionally optimal" if it maximizes P2's payoff
-- for *any* choice `a1` made by P1. This is the condition for backward
-- induction to be applicable at P2's information set.