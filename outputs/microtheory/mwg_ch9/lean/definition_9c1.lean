import Mathlib
open BigOperators Finset

/-- A system of beliefs in an extensive form game assigns a probability μ(x) ∈ [0, 1]
    to each decision node x, such that for every information set H,
    the probabilities of nodes in H sum to 1. -/
structure SystemOfBeliefs
    (Node : Type*) (InfoSet : Type*) [Fintype Node] [DecidableEq Node]
    [DecidableEq InfoSet] (infoSetOf : Node → InfoSet) where
  /-- Probability assigned to each decision node -/
  μ : Node → ℝ
  /-- Each probability is nonneg -/
  prob_nonneg : ∀ x, 0 ≤ μ x
  /-- Each probability is at most 1 -/
  prob_le_one : ∀ x, μ x ≤ 1
  /-- Probabilities sum to 1 over each information set -/
  sum_eq_one : ∀ H : InfoSet,
    ∑ x ∈ Finset.univ.filter (fun x => infoSetOf x = H), μ x = 1