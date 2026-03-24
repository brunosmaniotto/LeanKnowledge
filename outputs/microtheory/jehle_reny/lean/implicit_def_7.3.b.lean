import Mathlib
open Topology

/-- A behavioral strategy profile: probability of each action at each information set. -/
def BehavioralStrategyProfile (InfoSet Action : Type*) := InfoSet → Action → ℝ

/-- Conditional payoff in an extensive-form game (MWG Implicit Definition 7.3.b).

    Given an assessment (p, b) and a node x in an information set belonging to
    player i, u_i(b | x) denotes player i's expected payoff beginning from node x,
    calculated using the behavioral strategy b by treating x as if it defined
    a subgame. -/
structure ConditionalPayoff (Node Action Player InfoSet : Type*) where
  /-- Which player moves at each information set -/
  playerOf : InfoSet → Player
  /-- Which information set contains each node -/
  infoSetOf : Node → InfoSet
  /-- u_i(b | x): player i's expected payoff from node x under strategy profile b -/
  eval : BehavioralStrategyProfile InfoSet Action → Node → Player → ℝ