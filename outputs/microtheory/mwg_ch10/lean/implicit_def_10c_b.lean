import Mathlib
open Topology

/-- A firm's cost function for the two-good quasilinear model.
    Given cost function `c_j`, the production set is
    `Y_j = {(-z_j, q_j) : q_j ≥ 0 ∧ z_j ≥ c_j(q_j)}`.
    We require `c_j` to be twice differentiable with `c_j' > 0` and `c_j'' ≥ 0`
    on `(0, ∞)`. -/
structure FirmCostFunction where
  /-- The cost function `c_j : ℝ → ℝ` mapping output quantity to numeraire cost. -/
  cost : ℝ → ℝ
  /-- `c_j` is twice differentiable on `(0, ∞)`. -/
  twice_diff : ∀ q : ℝ, 0 < q → DifferentiableAt ℝ cost q ∧
    DifferentiableAt ℝ (deriv cost) q
  /-- Marginal cost is strictly positive: `c_j'(q) > 0` for all `q > 0`. -/
  marginal_pos : ∀ q : ℝ, 0 < q → 0 < deriv cost q
  /-- Cost function is convex: `c_j''(q) ≥ 0` for all `q > 0`. -/
  second_deriv_nonneg : ∀ q : ℝ, 0 < q → 0 ≤ deriv (deriv cost) q

/-- The production set for firm `j`: all feasible input-output pairs `(-z_j, q_j)`
    where `q_j ≥ 0` and `z_j ≥ c_j(q_j)`. -/
def FirmCostFunction.productionSet (firm : FirmCostFunction) : Set (ℝ × ℝ) :=
  {p | 0 ≤ p.2 ∧ firm.cost p.2 ≤ -p.1}