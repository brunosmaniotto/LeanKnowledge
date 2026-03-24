import Mathlib

open BigOperators Finset
open Topology

/-- A simple gamble over `n` outcomes: assigns probability `prob i` to each
    outcome `a_i`, where each probability is non-negative and the total is 1.
    Denoted (p_1 ∘ a_1, ..., p_n ∘ a_n). -/
structure SimpleGamble (n : ℕ) where
  prob : Fin n → ℝ
  prob_nonneg : ∀ i, 0 ≤ prob i
  prob_sum : ∑ i, prob i = 1