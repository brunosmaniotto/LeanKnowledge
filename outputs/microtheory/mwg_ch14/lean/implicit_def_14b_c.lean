import Mathlib
open BigOperators
open Topology

/-- Effort levels available to the manager. -/
inductive EffortLevel where
  | low  : EffortLevel
  | high : EffortLevel
  deriving DecidableEq, Repr

/-- A contract when effort is observable specifies the manager's effort
    and his wage as a function of observed profits, subject to the
    participation constraint that expected utility meets the reservation level. -/
structure ObservableEffortContract (ProfitState : Type*) [Fintype ProfitState] where
  /-- The effort level specified by the contract. -/
  effort : EffortLevel
  /-- Wage payment as a function of observed profit. -/
  wage : ProfitState → ℝ
  /-- Probability distribution over profits given the specified effort. -/
  prob : ProfitState → ℝ
  /-- Manager's von Neumann–Morgenstern utility over wages. -/
  utility : ℝ → ℝ
  /-- Reservation utility level ū. -/
  reservation : ℝ
  /-- Probabilities are nonneg. -/
  prob_nonneg : ∀ s, 0 ≤ prob s
  /-- Probabilities sum to 1. -/
  prob_sum : ∑ s, prob s = 1
  /-- Participation (individual rationality) constraint:
      the manager's expected utility is at least ū. -/
  participation : ∑ s, prob s * utility (wage s) ≥ reservation