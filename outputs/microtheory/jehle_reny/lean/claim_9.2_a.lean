import Mathlib

open Topology

/-- In the independent private values model with the seller's use value equal to zero
and the production decision already made, profit-maximisation for the seller is
equivalent to revenue-maximisation. -/
theorem Claim_9_2_a
    (revenue : ℝ → ℝ)  -- revenue as a function of some decision variable (e.g., reserve price)
    (cost : ℝ)          -- seller's cost
    (h_cost_zero : cost = 0)  -- cost is zero since object is already produced and use value is zero
    (profit : ℝ → ℝ)
    (h_profit_def : ∀ x, profit x = revenue x - cost) :
    (∀ x, profit x ≤ profit y) ↔ (∀ x, revenue x ≤ revenue y) := by
  constructor
  · intro h x
    have hp := h x
    rw [h_profit_def, h_profit_def] at hp
    linarith
  · intro h x
    rw [h_profit_def, h_profit_def]
    linarith [h x]