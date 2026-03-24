import Mathlib

open Finset BigOperators
open Topology
open BigOperators

noncomputable def indirectUtility (n : ℕ) (u : (Fin n → ℝ) → ℝ) (p : Fin n → ℝ) (w : ℝ) : ℝ :=
  sSup {v : ℝ | ∃ x : Fin n → ℝ, (∀ i, 0 ≤ x i) ∧ ∑ i, p i * x i ≤ w ∧ u x = v}

theorem indirectUtility_homogeneous_deg_zero (n : ℕ) (u : (Fin n → ℝ) → ℝ)
    (p : Fin n → ℝ) (w : ℝ) (t : ℝ) (ht : 0 < t) :
    indirectUtility n u (fun i => t * p i) (t * w) = indirectUtility n u p w := by
  unfold indirectUtility
  congr 1
  ext v
  simp only [Set.mem_setOf_eq]
  constructor
  · rintro ⟨x, hnn, hbudget, hval⟩
    refine ⟨x, hnn, ?_, hval⟩
    have : ∑ i : Fin n, t * p i * x i = t * ∑ i : Fin n, p i * x i := by
      rw [Finset.mul_sum]; congr 1; ext i; ring
    rw [this] at hbudget
    exact le_of_mul_le_mul_left hbudget ht
  · rintro ⟨x, hnn, hbudget, hval⟩
    refine ⟨x, hnn, ?_, hval⟩
    have : ∑ i : Fin n, t * p i * x i = t * ∑ i : Fin n, p i * x i := by
      rw [Finset.mul_sum]; congr 1; ext i; ring
    rw [this]
    exact mul_le_mul_of_nonneg_left hbudget (le_of_lt ht)