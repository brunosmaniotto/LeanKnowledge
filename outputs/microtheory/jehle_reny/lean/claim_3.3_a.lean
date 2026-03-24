import Mathlib

/-- **Profit maximization implies cost minimization** (MWG Claim 3.3a).
    For any firm (monopolist, perfect competitor, or otherwise), if a production
    plan maximizes profit, it must minimize input cost for the chosen output level.
    Revenue is held fixed (same output level), so the proof is independent of
    market structure. -/
theorem profit_max_implies_cost_min
    (revenue : ℝ)
    (cost : ℝ)
    (S : Set ℝ)
    (hcost : cost ∈ S)
    (h_profit_max : ∀ c ∈ S, revenue - cost ≥ revenue - c) :
    IsLeast S cost := by
  constructor
  · exact hcost
  · intro c hc
    linarith [h_profit_max c hc]