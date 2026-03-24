import Mathlib
open Topology

/-- A noncooperative game consists of four components:
(i) players, (ii) rules (modeled here as available actions per player),
(iii) outcomes (a function from action profiles to outcomes),
(iv) payoffs (utility functions over outcomes for each player). -/
structure Game (Player Action Outcome : Type*) where
  /-- Available actions for each player -/
  actions : Player → Set Action
  /-- Outcome function: given each player's chosen action, produce an outcome -/
  outcome : (Player → Action) → Outcome
  /-- Payoff (utility) function for each player over outcomes -/
  payoff : Player → Outcome → ℝ