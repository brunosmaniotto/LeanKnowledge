import Mathlib
open Classical -- For decidability of propositions, useful in game theory definitions
open Topology
set_option linter.unusedVariables false

-- Define players for a two-player game
inductive Player : Type
| P1 : Player
| P2 : Player
deriving DecidableEq, Repr

-- Define strategies for Player 1
inductive StrategyP1 : Type
| A1 : StrategyP1
| A2 : StrategyP1
deriving DecidableEq, Repr

-- Define strategies for Player 2
inductive StrategyP2 : Type
| B1 : StrategyP2
| B2 : StrategyP2
deriving DecidableEq, Repr

-- A joint strategy profile consisting of one strategy for each player
structure StrategyProfile : Type where
  s1 : StrategyP1
  s2 : StrategyP2
deriving Repr

-- Payoff function for Player 1 (using Matching Pennies payoffs as per proof sketch)
def payoffP1 (s : StrategyProfile) : Int :=
  match s.s1, s.s2 with
  | .A1, .B1 => 1
  | .A1, .B2 => -1
  | .A2, .B1 => -1
  | .A2, .B2 => 1

-- Payoff function for Player 2 (using Matching Pennies payoffs)