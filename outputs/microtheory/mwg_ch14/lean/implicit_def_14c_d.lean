import Mathlib
open Topology

/-- A revelation mechanism asks the manager to announce a state and maps announcements to outcomes. -/
structure RevelationMechanism (Θ : Type*) (Outcome : Type*) where
  /-- The outcome function mapping announced state to an outcome -/
  outcome : Θ → Outcome

/-- An incentive compatible (truthful) revelation mechanism is one where the manager
    always prefers to report the true state. Given a utility function that depends on
    the true state and the outcome, truthful reporting maximizes the manager's payoff. -/
structure ICRevelationMechanism (Θ : Type*) (Outcome : Type*) where
  /-- The underlying revelation mechanism -/
  mechanism : RevelationMechanism Θ Outcome
  /-- The manager's utility depends on the true state and the outcome received -/
  managerUtility : Θ → Outcome → ℝ
  /-- Incentive compatibility: for every true state θ, reporting θ truthfully is at least
      as good as reporting any other state θ' -/
  incentive_compatible : ∀ (θ θ' : Θ),
    managerUtility θ (mechanism.outcome θ) ≥ managerUtility θ (mechanism.outcome θ')