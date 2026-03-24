import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem every_good_has_substitute
    {L : ℕ} (hL : 0 < L)
    (D : Fin L → Fin L → ℝ)
    (p : Fin L → ℝ)
    (hp : ∀ j, 0 < p j)
    (hown : ∀ i, D i i ≤ 0)
    (heuler : ∀ ℓ, ∑ k ∈ univ, D ℓ k * p k = 0)
    (hstrict : ∀ ℓ, D ℓ ℓ < 0)
    (ℓ : Fin L) : ∃ k, D ℓ k > 0 := by
  by_contra h
  push_neg at h
  -- h : ∀ k, D ℓ k ≤ 0
  have hsum_nonpos : ∑ k ∈ univ, D ℓ k * p k ≤ 0 := by
    apply Finset.sum_nonpos
    intro k _
    exact mul_nonpos_of_nonpos_of_nonneg (h k) (le_of_lt (hp k))
  have hterm_neg : D ℓ ℓ * p ℓ < 0 := by
    exact mul_neg_of_neg_of_pos (hstrict ℓ) (hp ℓ)
  have hrest_nonpos : ∑ k ∈ univ.erase ℓ, D ℓ k * p k ≤ 0 := by
    apply Finset.sum_nonpos
    intro k _
    exact mul_nonpos_of_nonpos_of_nonneg (h k) (le_of_lt (hp k))
  have hsplit := heuler ℓ
  rw [← Finset.add_sum_erase _ _ (mem_univ ℓ)] at hsplit
  linarith