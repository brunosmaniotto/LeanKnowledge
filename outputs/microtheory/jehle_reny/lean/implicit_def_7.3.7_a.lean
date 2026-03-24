import Mathlib

open BigOperators

/-- A system of beliefs in an extensive form game.
    For each decision node `x`, `prob x` is the probability that the player moving at `x`
    assigns to the history reaching `x`, conditional on the information set containing `x`
    having been reached. Beliefs must sum to 1 over each information set. -/
structure SystemOfBeliefs (Node : Type*) (infoSet : Node → Finset Node) where
  /-- The probability assigned to each decision node. -/
  prob : Node → ℝ
  /-- Each probability is non-negative. -/
  prob_nonneg : ∀ x, 0 ≤ prob x
  /-- Each probability is at most 1. -/
  prob_le_one : ∀ x, prob x ≤ 1
  /-- Beliefs sum to 1 over each information set: ∑_{x ∈ I(y)} p(x) = 1. -/
  sum_eq_one : ∀ y, ∑ x ∈ infoSet y, prob x = 1