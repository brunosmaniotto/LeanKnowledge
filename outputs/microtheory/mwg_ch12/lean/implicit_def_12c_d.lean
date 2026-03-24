import Mathlib

/-
Definition (Implicit_Def_12C_d): Capacity constraints in duopoly pricing:
Each of two firms has constant marginal cost c > 0 and capacity constraint q̄ = (1/2)x(c).
Price announcements are commitments to supply demand only up to capacity.
Capacities are commonly known.

Context: This modifies the Bertrand model to account for capacity constraints.
-/
structure DuopolyCapacityConstraints where
  /-- The constant marginal cost for each firm. Must be positive. -/
  marginal_cost : ℝ
  /-- Proof that the marginal cost is positive. -/
  marginal_cost_pos : marginal_cost > 0
  /-- A function representing the quantity demanded given a price.
  The notation `x(c)` in the definition implies `x` is a function applied to `c`. -/
  demand_function : ℝ → ℝ
  /-- The capacity constraint for each firm. -/
  capacity_constraint : ℝ
  /-- The definition of the capacity constraint: `q̄ = (1/2) * x(c)`. -/
  capacity_definition : capacity_constraint = (1/2 : ℝ) * (demand_function marginal_cost)