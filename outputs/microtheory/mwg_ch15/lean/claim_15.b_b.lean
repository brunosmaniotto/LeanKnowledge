import Mathlib
open BigOperators
open Topology

theorem budget_set_invariant_under_scaling
    {n : ℕ} (p : Fin n → ℝ) (w : ℝ) (α : ℝ) (hα : 0 < α) :
    {x : Fin n → ℝ | ∑ i, (α * p i) * x i ≤ α * w} =
    {x : Fin n → ℝ | ∑ i, p i * x i ≤ w} := by
  ext x
  simp only [Set.mem_setOf_eq]
  have key : ∑ i, (α * p i) * x i = α * ∑ i, p i * x i := by
    rw [Finset.mul_sum]; congr 1; ext i; ring
  rw [key]
  constructor
  · intro h; nlinarith
  · intro h; nlinarith