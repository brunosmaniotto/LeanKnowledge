import Mathlib

open Finset BigOperators
open Topology
open BigOperators

variable {S : Type*} [Fintype S] [DecidableEq S] [Nonempty S]

theorem optimal_probabilistic_implies_deterministic
    (payoff_i : S → ℝ) (w : S → ℝ)
    (hw_nonneg : ∀ s, 0 ≤ w s)
    (hw_sum : ∑ s : S, w s = 1) :
    ∃ s_star : S, ∑ s : S, w s * payoff_i s ≤ payoff_i s_star := by
  by_contra h
  push_neg at h
  have hpos : ∃ s₀ : S, 0 < w s₀ := by
    by_contra hall
    push_neg at hall
    have : ∑ s : S, w s = 0 := Finset.sum_eq_zero (fun s _ => le_antisymm (hall s) (hw_nonneg s))
    linarith
  obtain ⟨s₀, hs₀⟩ := hpos
  have key : ∑ s : S, w s * payoff_i s < ∑ s : S, w s * payoff_i s := calc
    ∑ s : S, w s * payoff_i s
      < ∑ s : S, w s * (∑ s : S, w s * payoff_i s) := by
        apply Finset.sum_lt_sum
        · intro s _
          exact mul_le_mul_of_nonneg_left (le_of_lt (h s)) (hw_nonneg s)
        · exact ⟨s₀, Finset.mem_univ s₀, by nlinarith [h s₀]⟩
    _ = ∑ s : S, w s * payoff_i s := by
        simp_rw [← Finset.sum_mul]
        rw [hw_sum, one_mul]
  linarith