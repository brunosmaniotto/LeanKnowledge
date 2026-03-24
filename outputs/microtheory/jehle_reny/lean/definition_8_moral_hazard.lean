import Mathlib
open Topology

/-- Moral hazard: a principal-agent setting where the principal's payoff depends
    on the agent's action, but the action is unobservable. The principal can
    only write contracts contingent on observable outcomes, not on the action.
    In the insurance context: the insurer (principal) cannot observe the
    consumer's (agent's) driving effort. -/
structure MoralHazard where
  /-- The agent's effort or action space (e.g., driving care levels) -/
  Action : Type
  /-- The space of observable outcomes (e.g., accident / no accident) -/
  Outcome : Type
  /-- Probability of each outcome given the agent's action -/
  prob : Action → Outcome → ℝ
  /-- The principal's gross payoff from each outcome -/
  principalPayoff : Outcome → ℝ
  /-- The wage/coverage contract, contingent only on outcome — NOT on action.
      This is what encodes unobservability of the agent's action. -/
  wage : Outcome → ℝ
  /-- The agent's cost or disutility of effort -/
  agentCost : Action → ℝ
  /-- The principal has a stake: different actions yield different outcome
      distributions, so the principal's expected payoff depends on the action. -/
  stake : ∃ a₁ a₂ : Action, prob a₁ ≠ prob a₂