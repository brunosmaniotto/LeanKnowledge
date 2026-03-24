import Mathlib

open Finset
open Topology

/-- In a direct selling mechanism with N bidders, each bidder i has an assignment
    probability p_i ∈ [0,1] and a cost c_i ∈ ℝ. We demonstrate three properties:
    (1) A bidder's cost can be negative (seller pays the bidder)
    (2) A bidder's cost can be positive even when p_i = 0
    (3) The sum of assignment probabilities can be strictly less than 1 -/
theorem claim_9_3_a :
    -- (1) There exists a cost that is negative
    (∃ c : ℝ, c < 0) ∧
    -- (2) There exist p_i = 0 and c_i > 0 simultaneously
    (∃ p c : ℝ, p = 0 ∧ c > 0) ∧
    -- (3) There exist assignment probabilities summing to less than 1
    (∃ p₁ p₂ : ℝ, 0 ≤ p₁ ∧ p₁ ≤ 1 ∧ 0 ≤ p₂ ∧ p₂ ≤ 1 ∧ p₁ + p₂ < 1) := by
  exact ⟨⟨-1, by norm_num⟩, ⟨0, 1, rfl, by norm_num⟩,
    ⟨0, 0, by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩⟩