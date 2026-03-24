import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Claim_6E_b
    {n : ℕ} (hn : 0 < n)
    (a : Fin n → ℝ)
    (ha_nonneg : ∀ i, 0 ≤ a i)
    (ha_pos : ∃ j, 0 < a j)
    (W : (Fin n → ℝ) → ℝ)
    (hW : ∀ u, W u = ∑ i : Fin n, a i * u i) :
    (∀ u u' : Fin n → ℝ, (∀ i, u i ≤ u' i) → W u ≤ W u') ∧
    (∀ u u' : Fin n → ℝ, (∀ i, u i < u' i) → W u < W u') := by
  constructor
  · intro u u' hle
    rw [hW u, hW u']
    apply Finset.sum_le_sum
    intro i _
    exact mul_le_mul_of_nonneg_left (hle i) (ha_nonneg i)
  · intro u u' hlt
    rw [hW u, hW u']
    apply Finset.sum_lt_sum
    · intro i _
      exact mul_le_mul_of_nonneg_left (le_of_lt (hlt i)) (ha_nonneg i)
    · obtain ⟨j, haj⟩ := ha_pos
      exact ⟨j, mem_univ j, mul_lt_mul_of_pos_left (hlt j) haj⟩