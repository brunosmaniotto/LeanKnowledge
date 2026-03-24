import Mathlib
open BigOperators

/-- A decision framework where each alternative leads to outcomes with objectively known probabilities.
    This captures MWG Definition 6.B.b: probabilities of outcomes are objectively known. -/
structure ObjectivelyKnownProbabilities (Alternative : Type*) (Outcome : Type*) [Fintype Outcome] where
  /-- The probability distribution over outcomes for each alternative -/
  prob : Alternative → Outcome → ℝ
  /-- Probabilities are non-negative -/
  prob_nonneg : ∀ a o, 0 ≤ prob a o
  /-- Probabilities sum to one for each alternative -/
  prob_sum_one : ∀ a, ∑ o : Outcome, prob a o = 1