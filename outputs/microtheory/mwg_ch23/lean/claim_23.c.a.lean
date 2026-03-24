import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/--
Weak dominance via expected utility over all opponent strategy functions
is equivalent to pointwise dominance over all opponent action profiles,
when the opponent type space is finite.
-/
theorem weakly_dominant_strategy_equiv
    {Θ_i S_i S_minus_i Θ_minus_i : Type*}
    [Fintype Θ_minus_i] [DecidableEq S_minus_i]
    (u : S_i → S_minus_i → Θ_i → ℝ)
    (prob : Θ_minus_i → ℝ)
    (hprob_nonneg : ∀ t, 0 ≤ prob t)
    (hprob_sum : ∑ t : Θ_minus_i, prob t = 1)
    (s_i : Θ_i → S_i)
    (θ_i : Θ_i) :
    -- Pointwise dominance (23.C.2): for all ŝ_i and all s_{-i}
    (∀ (ŝ_i : S_i) (s_minus_i : S_minus_i),
      u (s_i θ_i) s_minus_i θ_i ≥ u ŝ_i s_minus_i θ_i)
    ↔
    -- Expected utility dominance (23.C.1): for all ŝ_i and all opponent strategy functions
    (∀ (ŝ_i : S_i) (σ : Θ_minus_i → S_minus_i),
      ∑ t : Θ_minus_i, prob t * u (s_i θ_i) (σ t) θ_i ≥
      ∑ t : Θ_minus_i, prob t * u ŝ_i (σ t) θ_i) := by
  constructor
  · -- (23.C.2) → (23.C.1): pointwise dominance implies expected utility dominance
    intro h ŝ_i σ
    apply Finset.sum_le_sum
    intro t _
    exact mul_le_mul_of_nonneg_left (h ŝ_i (σ t)) (hprob_nonneg t)
  · -- (23.C.1) → (23.C.2): set σ to constant function
    intro h ŝ_i s_minus_i
    have h_const := h ŝ_i (fun _ => s_minus_i)
    simp only [ge_iff_le] at h_const ⊢
    have lhs : ∑ t : Θ_minus_i, prob t * u ŝ_i s_minus_i θ_i =
               u ŝ_i s_minus_i θ_i * ∑ t : Θ_minus_i, prob t := by
      rw [Finset.mul_sum]; congr 1; ext t; ring
    have rhs : ∑ t : Θ_minus_i, prob t * u (s_i θ_i) s_minus_i θ_i =
               u (s_i θ_i) s_minus_i θ_i * ∑ t : Θ_minus_i, prob t := by
      rw [Finset.mul_sum]; congr 1; ext t; ring
    rw [lhs, rhs, hprob_sum, mul_one, mul_one] at h_const
    exact h_const