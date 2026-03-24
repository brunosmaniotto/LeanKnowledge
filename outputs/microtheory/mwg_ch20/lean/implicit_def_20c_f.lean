import Mathlib

open Filter

/-- The transversality condition for a production path and a price sequence:
    the present value of the period t production plan for period t+1 goes to zero,
    i.e., p_{t+1} · y_{a,t} → 0 as t → ∞. -/
noncomputable def transversalityCondition
    (p : ℕ → ℝ) (y_a : ℕ → ℝ) : Prop :=
  Filter.Tendsto (fun t => p (t + 1) * y_a t) atTop (nhds 0)