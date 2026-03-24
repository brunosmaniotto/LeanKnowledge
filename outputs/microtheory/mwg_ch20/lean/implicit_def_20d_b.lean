import Mathlib

/-- A production path assigns to each time period t a production vector (y_a, y_b) in the production set Y. -/
structure ProductionPath where
  /-- The "a" component of production at time t (output carried forward) -/
  y_a : ℕ → ℝ
  /-- The "b" component of production at time t (output available now) -/
  y_b : ℕ → ℝ

/-- The induced consumption stream from a production path and endowment stream.
    c_t = y_{a,t-1} + y_{b,t} + ω_t, where y_{a,-1} is taken to be 0. -/
noncomputable def inducedConsumption (p : ProductionPath) (ω : ℕ → ℝ) (t : ℕ) : ℝ :=
  match t with
  | 0     => p.y_b 0 + ω 0
  | t + 1 => p.y_a t + p.y_b (t + 1) + ω (t + 1)

/-- A production path is feasible if the induced consumption is nonneg at every period. -/
def ProductionPath.IsFeasible (p : ProductionPath) (ω : ℕ → ℝ) : Prop :=
  ∀ t, 0 ≤ inducedConsumption p ω t