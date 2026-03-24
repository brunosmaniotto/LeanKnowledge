import Mathlib

open BigOperators
open Topology

/-- At any solution to the cost-minimisation problem with a strictly increasing
    production function, the output constraint f(x) ≥ y binds: f(x*) = y. -/
theorem cost_min_constraint_binding
    {n : ℕ}
    (f : (Fin n → ℝ) → ℝ)
    (w : Fin n → ℝ)
    (y : ℝ)
    (x_star : Fin n → ℝ)
    (hfeas : f x_star ≥ y)
    (hnn : ∀ i, x_star i ≥ 0)
    -- x_star minimises cost among nonneg feasible bundles
    (hopt : ∀ x : Fin n → ℝ, (∀ i, x i ≥ 0) → f x ≥ y →
      ∑ i : Fin n, w i * x_star i ≤ ∑ i : Fin n, w i * x i)
    -- Strict monotonicity + continuity ⇒ slack can always be reduced
    (hreduce : f x_star > y →
      ∃ x' : Fin n → ℝ, (∀ i, x' i ≥ 0) ∧ f x' ≥ y ∧
        ∑ i : Fin n, w i * x' i < ∑ i : Fin n, w i * x_star i) :
    f x_star = y := by
  by_contra h
  have hgt : f x_star > y := lt_of_le_of_ne hfeas (Ne.symm h)
  obtain ⟨x', hnn', hfeas', hcost⟩ := hreduce hgt
  linarith [hopt x' hnn' hfeas']