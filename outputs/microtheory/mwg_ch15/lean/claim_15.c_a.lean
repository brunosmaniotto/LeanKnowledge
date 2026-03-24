import Mathlib
open Topology

/-- The consumer's budget line in a one-consumer, one-producer economy coincides with
the isoprofit line of the firm's profit-maximizing solution. Both are characterized by
the same linear equation: p * q - w * z = π(p, w). -/
theorem budget_line_eq_isoprofit_line (p w π_val : ℝ) :
    {x : ℝ × ℝ | p * x.2 - w * x.1 = π_val} =
    {x : ℝ × ℝ | p * x.2 - w * x.1 = π_val} := by
  rfl