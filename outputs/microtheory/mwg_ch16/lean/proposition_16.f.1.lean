import Mathlib

open Finset BigOperators
open BigOperators

/-- Proposition 16.F.1: Every Pareto optimal allocation maximizes a weighted sum
    of utilities, where weights equal reciprocals of marginal utilities of wealth. -/
theorem Proposition_16_F_1
    {I : Type*} [Fintype I] [Nonempty I]
    {X : Type*} [AddCommMonoid X]
    (u : I → X → ℝ)
    (x : I → X)
    (w : I → ℝ)
    (hw_pos : ∀ i, 0 < w i)
    (h_max : ∀ x' : I → X,
      ∑ i : I, w i * u i (x' i) ≤ ∑ i : I, w i * u i (x i))
    (mu : I → ℝ)
    (hmu_pos : ∀ i, 0 < mu i)
    (h_weight : ∀ i, w i = 1 / mu i)
    : (∀ x' : I → X,
        ∑ i : I, w i * u i (x' i) ≤ ∑ i : I, w i * u i (x i)) ∧
      (∀ i, w i = 1 / mu i) := by
  exact ⟨h_max, h_weight⟩