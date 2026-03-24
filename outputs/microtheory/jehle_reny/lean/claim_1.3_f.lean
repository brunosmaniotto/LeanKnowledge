import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Claim_1_3_f {n : ℕ} (hn : 0 < n) (p x : Fin n → ℝ)
    (hp : ∀ i, 0 < p i)
    (hx_nonneg : ∀ i, 0 ≤ x i)
    (y : ℝ) (hy : 0 < y)
    (hbudget : ∑ i, p i * x i = y) :
    (∀ i, 0 ≤ x i) ∧ x ≠ 0 ∧ ∃ i, 0 < x i := by
  refine ⟨hx_nonneg, ?_, ?_⟩
  · intro hx0
    have : ∑ i, p i * x i = 0 := by
      subst hx0
      simp
    linarith
  · by_contra h
    push_neg at h
    have hle : ∀ i, x i = 0 := fun i => le_antisymm (h i) (hx_nonneg i)
    have : ∑ i, p i * x i = 0 := by
      apply Finset.sum_eq_zero
      intro i _
      simp [hle i]
    linarith