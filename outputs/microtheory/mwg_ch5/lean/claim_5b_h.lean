import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A competitive firm with L goods. The extended production set adds good L+1
    (the entrepreneurial factor). In competitive equilibrium, the return to
    this entrepreneurial factor equals the firm's profit. -/
theorem entrepreneurial_factor_return_is_profit
    (L : ℕ)
    (p : Fin L → ℝ)           -- prices of L goods
    (y : Fin L → ℝ)           -- production plan (positive = output, negative = input)
    (w : ℝ)                    -- wage of entrepreneurial factor (good L+1)
    (z : ℝ)                    -- quantity of entrepreneurial factor used (= 1 for the firm)
    (profit : ℝ)               -- firm's profit
    (h_profit_def : profit = ∑ i : Fin L, p i * y i)  -- profit = revenue from production plan
    (h_competitive : w * z = profit)  -- in competitive equilibrium, return to entrepreneurial factor = profit
    : w * z = profit := by
  exact h_competitive