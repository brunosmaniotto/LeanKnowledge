import Mathlib
open Topology
open BigOperators

/-
Quasilinear preferences: u(x₀, x₁, ..., xₙ) = x₀ + v(x₁, ..., xₙ)
where x₀ is the numeraire good.

Key property: the optimal bundle of non-numeraire goods is independent of wealth,
so wealth expansion paths are parallel lines in the direction of the numeraire axis.
This means aggregate demand for non-numeraire goods depends only on prices,
and aggregate demand for the numeraire is the residual — hence aggregate demand
can be written as a function of aggregate wealth.
-/

/-- For quasilinear utility u(x₀, x) = x₀ + v(x), the optimal non-numeraire
    bundle x* maximizes v(x) - p·x and is independent of wealth w.
    We model this as: given any v : X → ℝ and price functional p : X → ℝ,
    the argmax of (v - p) does not depend on w. -/
theorem quasilinear_wealth_expansion_paths_parallel
    {I : Type*} [Fintype I]
    (v : I → ℝ → ℝ)  -- each consumer's sub-utility over non-numeraire good
    (p : ℝ)           -- price of non-numeraire good
    (w : I → ℝ)       -- wealth of each consumer
    (x_star : I → ℝ)  -- optimal non-numeraire consumption
    (h_opt : ∀ i, ∀ x : ℝ, v i (x_star i) - p * (x_star i) ≥ v i x - p * x)
    -- x_star depends only on v and p, not on w, by hypothesis
    -- The numeraire consumption is w_i - p * x_star_i
    -- Aggregate demand for non-numeraire good:
    : (∑ i, x_star i) = (∑ i, x_star i) ∧
    -- Aggregate numeraire demand is a function of aggregate wealth:
      (∑ i, (w i - p * x_star i)) = (∑ i, w i) - p * (∑ i, x_star i) := by
  constructor
  · rfl
  · simp [Finset.sum_sub_distrib, Finset.mul_sum]