import Mathlib

open BigOperators Finset
open Topology

/-- The consumer's demand functions are homogeneous of degree zero in prices
    and income: scaling all prices and wealth by the same positive factor α
    leaves the budget set unchanged, so demand behaviour is unchanged. -/
theorem demand_homogeneous_degree_zero
    {n : ℕ} (p : Fin n → ℝ) (w : ℝ) (α : ℝ) (hα : 0 < α) :
    {x : Fin n → ℝ | ∑ i, (α * p i) * x i ≤ α * w} =
    {x : Fin n → ℝ | ∑ i, p i * x i ≤ w} := by
  ext x
  simp only [Set.mem_setOf_eq]
  constructor
  · intro h
    have : ∑ i, (α * p i) * x i = α * ∑ i, p i * x i := by
      simp [mul_assoc, Finset.mul_sum]
    rw [this] at h
    exact le_of_mul_le_mul_left h hα
  · intro h
    have : ∑ i, (α * p i) * x i = α * ∑ i, p i * x i := by
      simp [mul_assoc, Finset.mul_sum]
    rw [this]
    exact mul_le_mul_of_nonneg_left h (le_of_lt hα)