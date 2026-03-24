import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem mixed_nash_indifference_determines_probabilities
    {S : Type*} [Fintype S] [DecidableEq S]
    (u : S → ℝ) (σ : S → ℝ) (support : Finset S) (v : ℝ)
    (h_prob : ∑ s ∈ support, σ s = 1)
    (h_nonneg : ∀ s ∈ support, 0 ≤ σ s)
    (h_support : ∀ s, s ∉ support → σ s = 0)
    (h_indiff : ∀ s ∈ support, u s = v) :
    ∑ s ∈ support, σ s * u s = v := by
  have : ∑ s ∈ support, σ s * u s = ∑ s ∈ support, σ s * v := by
    apply Finset.sum_congr rfl
    intro s hs
    rw [h_indiff s hs]
  rw [this, ← Finset.sum_mul, h_prob, one_mul]