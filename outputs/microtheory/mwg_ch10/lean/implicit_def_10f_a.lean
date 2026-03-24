import Mathlib
open Topology

-- We define `averageCost` as noncomputable because division by a variable `q`
-- makes the function generally noncomputable in Lean 4.
noncomputable def averageCost (c : ℝ → ℝ) (q : ℝ) : ℝ :=
  c q / q

/--
A firm's efficient scale is a strictly positive output level `q̄` at which its average costs
`c(q)/q` are minimized. The minimized average cost is `c̄ = c(q̄)/q̄`.
-/
structure EfficientScale (c : ℝ → ℝ) where
  /-- The strictly positive output level that minimizes average costs. -/
  q_bar : ℝ
  /-- The minimized average cost at the efficient scale `q_bar`. -/
  c_bar : ℝ
  /-- The efficient scale `q_bar` must be strictly positive. -/
  q_bar_pos : q_bar > 0
  /-- The minimized average cost `c_bar` is equal to the average cost at `q_bar`. -/
  c_bar_eq_average_cost_at_q_bar : c_bar = averageCost c q_bar
  /-- The output level `q_bar` minimizes the average cost for all strictly positive `q`. -/
  q_bar_minimizes_average_cost : ∀ (q : ℝ), q > 0 → averageCost c q_bar ≤ averageCost c q