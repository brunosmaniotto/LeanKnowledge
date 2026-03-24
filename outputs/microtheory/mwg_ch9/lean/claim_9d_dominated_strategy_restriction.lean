import Mathlib

/-- Actions available to the entrant -/
inductive EntryAction
  | in₁ | in₂ | out
  deriving DecidableEq

/-- A belief at the post-entry information set -/
structure Belief where
  prob_in₁ : ℝ
  prob_in₂ : ℝ
  nonneg₁ : 0 ≤ prob_in₁
  nonneg₂ : 0 ≤ prob_in₂
  sum_one : prob_in₁ + prob_in₂ = 1

/-- Reasonable beliefs assign zero probability to strictly dominated strategies -/
theorem dominated_strategy_restriction
    (μ : Belief) (payoff_in₁ payoff_in₂ : ℝ)
    (h_dom : payoff_in₁ > payoff_in₂)
    (h_reasonable : μ.prob_in₂ = 0) :
    μ.prob_in₁ = 1 := by
  have := μ.sum_one
  linarith