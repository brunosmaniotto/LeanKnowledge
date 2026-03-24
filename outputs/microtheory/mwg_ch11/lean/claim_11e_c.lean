import Mathlib

open Set
open Topology
open WithTop

-- Marginal cost function for Case (a): zero up to h_star, infinite thereafter.
-- `noncomputable` is required because `Real.decidableLE` (used implicitly by `if-then-else` on `ℝ`) is noncomputable.
noncomputable def mc_case_a (h_star : ℝ) (h_val : ℝ) : WithTop ℝ :=
  if h_val ≤ h_star then (0 : WithTop ℝ) else ⊤

-- Marginal cost function for Case (b): constant value `c`.
def mc_case_b (c : ℝ) (h_val : ℝ) : ℝ := c

-- Trivial property for `mc_case_a`: If the externality `h_val` is less than or equal to `h_star`,
-- the marginal cost is zero.