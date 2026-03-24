import Mathlib

open MeasureTheory
open Topology

/-- The principal-agent problem: the principal designs an incentive scheme
    so that the agent takes an appropriate action under moral hazard. -/
structure PrincipalAgentProblem where
  /-- Type of possible actions the agent can take -/
  Action : Type*
  /-- Type of possible outcomes -/
  Outcome : Type*
  /-- The agent's utility as a function of action and payment -/
  agentUtility : Action → ℝ → ℝ
  /-- The principal's payoff as a function of outcome and payment -/
  principalPayoff : Outcome → ℝ → ℝ
  /-- Incentive scheme: maps outcomes to payments -/
  incentiveScheme : Outcome → ℝ
  /-- The agent's reservation utility (outside option) -/
  reservationUtility : ℝ
  /-- Moral hazard: the principal cannot directly observe the agent's action -/
  actionUnobservable : Prop
  /-- The action the principal wishes to implement -/
  targetAction : Action

/-- An incentive scheme is feasible if the agent weakly prefers the target action
    and participation is individually rational. -/
structure OwnerProblem14C8.IsFeasible (P : PrincipalAgentProblem) : Prop where
  /-- Incentive compatibility: target action maximizes the agent's expected utility -/
  incentive_compatible : ∀ a : P.Action,
    P.agentUtility P.targetAction 0 ≥ P.agentUtility a 0
  /-- Individual rationality: agent gets at least reservation utility -/
  individually_rational :
    P.agentUtility P.targetAction 0 ≥ P.reservationUtility