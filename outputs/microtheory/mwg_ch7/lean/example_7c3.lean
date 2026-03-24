import Mathlib
open Topology

/-- Actions in Matching Pennies. -/
inductive MPCoin where
  | Heads | Tails
deriving DecidableEq, Repr, Fintype

/-- Matching Pennies Version C: Player 1 moves first but keeps her penny
    covered, so player 2 cannot observe player 1's choice. Player 2's two
    decision nodes form a single information set. -/
structure MatchingPenniesC where
  p1 : MPCoin
  p2 : MPCoin

namespace MatchingPenniesC

def payoff₁ (g : MatchingPenniesC) : Int :=
  if g.p1 = g.p2 then 1 else -1