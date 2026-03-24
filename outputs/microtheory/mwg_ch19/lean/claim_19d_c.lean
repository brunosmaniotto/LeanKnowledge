import Mathlib
open BigOperators
open Topology

theorem radner_budget_homogeneity_degree_zero
    {n : ℕ} (p x : Fin n → ℝ) (w : ℝ) (t : ℝ) (ht : t > 0) :
    (∑ i, (t * p i) * x i ≤ t * w) ↔ (∑ i, p i * x i ≤ w) := by
  have ht' : 0 < t := ht
  simp only [mul_assoc]
  rw [← Finset.mul_sum]
  constructor
  · exact fun h => le_of_mul_le_mul_left h ht'
  · exact fun h => mul_le_mul_of_nonneg_left h (le_of_lt ht')