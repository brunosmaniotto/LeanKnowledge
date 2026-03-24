import Mathlib
open BigOperators

/-- A move of nature (random move) is a chance node where nature plays actions
    with fixed, exogenously given probabilities. -/
structure MoveOfNature (Action : Type*) [Fintype Action] where
  /-- The probability assigned to each action at this chance node. -/
  prob : Action → ℝ
  /-- All probabilities are non-negative. -/
  prob_nonneg : ∀ a, 0 ≤ prob a
  /-- Probabilities sum to 1. -/
  prob_sum_one : ∑ a, prob a = 1