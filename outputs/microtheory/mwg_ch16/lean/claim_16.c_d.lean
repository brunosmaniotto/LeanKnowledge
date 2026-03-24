import Mathlib

open BigOperators Finset

theorem feasible_allocation_cost_eq
    {I J : Type*} [Fintype I] [Fintype J]
    {L : Type*} [Fintype L]
    (p : L → ℝ) (ω : L → ℝ)
    (x : I → L → ℝ) (y : J → L → ℝ)
    (feasibility : ∀ l, ∑ i, x i l = ω l + ∑ j, y j l) :
    ∑ l, ∑ i, p l * x i l = ∑ l, p l * ω l + ∑ l, ∑ j, p l * y j l := by
  rw [← sum_add_distrib]
  congr 1
  ext l
  rw [← mul_sum, ← mul_sum, ← mul_add, feasibility]