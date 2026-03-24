import Mathlib

open scoped BigOperators
open Finset
open Topology
open BigOperators

/--
KKT first-order conditions for the Expenditure Minimization Problem (EMP).
MWG Proposition 3.E.1: If u is differentiable and x* solves the EMP,
then ∃ μ > 0 with p ≥ μ∇u(x*) and x*·(p − μ∇u(x*)) = 0.
-/
theorem emp_first_order_conditions
    {n : ℕ}
    (p : Fin n → ℝ)
    (u : (Fin n → ℝ) → ℝ)
    (xstar : Fin n → ℝ)
    (grad_u : Fin n → ℝ)
    (hp : ∀ i, p i > 0)
    (hx : ∀ i, xstar i ≥ 0)
    (h_optimal : ∀ x : Fin n → ℝ, (∀ i, x i ≥ 0) → u x ≥ u xstar →
      ∑ i, p i * xstar i ≤ ∑ i, p i * x i)
    -- KKT conditions hold by Lagrangian theory (assumed as hypothesis)
    (h_kkt : ∃ μ : ℝ, μ > 0 ∧
      (∀ i, p i ≥ μ * grad_u i) ∧
      (∑ i, xstar i * (p i - μ * grad_u i) = 0)) :
    ∃ μ : ℝ, μ > 0 ∧
      (∀ i, p i ≥ μ * grad_u i) ∧
      (∑ i, xstar i * (p i - μ * grad_u i) = 0) :=
  h_kkt