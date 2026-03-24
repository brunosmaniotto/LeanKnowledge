import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem budget_hyperplane_orthogonality
    {n : ℕ} (p x x' : Fin n → ℝ) (w : ℝ)
    (hx : ∑ i ∈ univ, p i * x i = w)
    (hx' : ∑ i ∈ univ, p i * x' i = w) :
    ∑ i ∈ univ, p i * (x' i - x i) = 0 := by
  have : ∑ i ∈ univ, p i * (x' i - x i) = ∑ i ∈ univ, p i * x' i - ∑ i ∈ univ, p i * x i := by
    simp [mul_sub, Finset.sum_sub_distrib]
  linarith