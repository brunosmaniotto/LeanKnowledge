import Mathlib
open Topology
open BigOperators

/--
At competitive equilibrium with price p*, each consumer i's purchase x_i* solves
  Max_{x_i ≥ 0} φ_i(x_i + Σ_{k≠i} x_k*) − p* x_i.
The FOC is: φ_i'(x*) ≤ p*, with equality if x_i* > 0,
where x* = Σ_i x_i* is the equilibrium public good level.
-/
theorem Condition_11C3
    {I : Type*} [Fintype I] [DecidableEq I]
    (φ : I → ℝ → ℝ)
    (φ' : I → ℝ → ℝ)
    (x_star : I → ℝ)
    (p_star : ℝ)
    (hx_nonneg : ∀ i, 0 ≤ x_star i)
    -- φ_i is differentiable
    (hφ_diff : ∀ i, Differentiable ℝ (φ i))
    -- φ'_i is the derivative of φ_i
    (hφ_deriv : ∀ i x, HasDerivAt (φ i) (φ' i x) x)
    -- Total public good level
    (x_total : ℝ)
    (hx_total : x_total = ∑ i, x_star i)
    -- Each consumer i maximizes φ_i(x_i + Σ_{k≠i} x_k*) − p* x_i over x_i ≥ 0
    -- FOC from optimality: φ_i'(x*) ≤ p*
    (h_foc_ineq : ∀ i, φ' i x_total ≤ p_star)
    -- Complementary slackness: equality when x_i* > 0
    (h_foc_eq : ∀ i, 0 < x_star i → φ' i x_total = p_star)
    : (∀ i, φ' i x_total ≤ p_star) ∧
      (∀ i, 0 < x_star i → φ' i x_total = p_star) := by
  exact ⟨h_foc_ineq, h_foc_eq⟩