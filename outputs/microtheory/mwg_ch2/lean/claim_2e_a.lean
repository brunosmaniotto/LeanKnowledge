import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem budget_set_homogeneous {n : ℕ} (p : Fin n → ℝ) (w : ℝ) (α : ℝ) (hα : 0 < α) :
    {x : Fin n → ℝ | ∑ i, α * p i * x i ≤ α * w} = {x : Fin n → ℝ | ∑ i, p i * x i ≤ w} := by
  ext x
  simp only [Set.mem_setOf_eq]
  have key : ∑ i : Fin n, α * p i * x i = α * ∑ i : Fin n, p i * x i := by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i _
    ring
  rw [key]
  constructor
  · exact fun h => le_of_mul_le_mul_left h hα
  · exact fun h => mul_le_mul_of_nonneg_left h (le_of_lt hα)