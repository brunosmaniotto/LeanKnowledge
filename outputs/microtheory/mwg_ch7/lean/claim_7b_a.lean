import Mathlib
open Topology

-- Model Matching Pennies: two players, two actions each
inductive MPAction : Type
  | Heads : MPAction
  | Tails : MPAction
  deriving DecidableEq

-- Player 1's payoff in Matching Pennies (wants to match)
def mp_payoff_p1 : MPAction → MPAction → ℤ
  | MPAction.Heads, MPAction.Heads => 1
  | MPAction.Heads, MPAction.Tails => -1
  | MPAction.Tails, MPAction.Heads => -1
  | MPAction.Tails, MPAction.Tails => 1

-- Player 2's payoff in Matching Pennies (wants to mismatch)