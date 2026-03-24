import Mathlib
open Topology

structure BertrandModel where
  demand_function : ℝ → ℝ
  unit_cost : ℝ

  -- Demand function is continuous on the set of prices where demand is positive.
  demand_continuous_on_pos : ContinuousOn demand_function {p | demand_function p > 0}
  -- Demand function is strictly decreasing on the set of prices where demand is positive.
  demand_strictly_decreasing_on_pos : StrictAntiOn demand_function {p | demand_function p > 0}
  -- There exists a finite maximum price p_bar such that for all prices p greater than or equal to p_bar, the demand is zero.
  exists_finite_max_price : ∃ p_bar : ℝ, ∀ p, p_bar ≤ p → demand_function p = 0

  -- Unit cost must be positive.
  unit_cost_pos : unit_cost > 0
  -- Demand at the unit cost must be positive (and implicitly finite by ℝ type).
  demand_at_cost_pos : demand_function unit_cost > 0

  -- Sales function for firm j, given its price p_j and competitor's price p_k.
  sales_function (p_j p_k : ℝ) : ℝ :=
    if p_j < p_k then demand_function p_j
    else if p_j = p_k then (1/2 : ℝ) * demand_function p_j
    else 0

  -- Profit function for firm j, given its price p_j and competitor's price p_k.
  profit_function (p_j p_k : ℝ) : ℝ :=
    (p_j - unit_cost) * (sales_function p_j p_k)