import Mathlib

-- Define types for agents (I) and firms (J)
variable {I J : Type*} [Fintype I] [Fintype J]

-- Quantities of goods for agents (x_i) and firms (q_j), and the market price (p)
-- We assume quantities are real numbers. In a typical economic model, these would be non-negative.
variable (x : I → ℝ) (q : J → ℝ) (p : ℝ)

-- Marginal utility functions for agents and marginal cost functions for firms.
-- These are assumed to be given functions, representing the derivatives of underlying utility/cost functions.
variable (φ_marginal : I → ℝ → ℝ) (c_marginal : J → ℝ → ℝ)

-- Definition of condition (10.C.1): Firm profit maximization FOCs
-- p* ≤ c_j'(q_j*), with equality if q_j* > 0, for j = 1, ..., J
def firm_foc_condition (x : I → ℝ) (q : J → ℝ) (p : ℝ) (c_marginal : J → ℝ → ℝ) : Prop :=
  ∀ j : J, (p ≤ c_marginal j (q j)) ∧ (0 < q j → p = c_marginal j (q j))

-- Definition of condition (10.C.2): Agent utility maximization FOCs
-- φ_i'(x_i*) ≤ p*, with equality if x_i* > 0, for i = 1, ..., I