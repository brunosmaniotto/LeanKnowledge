import Mathlib

/-- In a pooling equilibrium with positive benefits, zero total expected profit
    implies the insurer earns strictly positive profit on low-risk consumers. -/
theorem claim_8_4_zero_profit_low_risk_positive
    (α p B πL πH : ℝ)
    (hα_pos : 0 < α) (hα_lt : α < 1)
    (hB_pos : B > 0)
    (hπ_lt : πL < πH)
    (h_zero_profit : α * (p - πL * B) + (1 - α) * (p - πH * B) = 0) :
    p - πL * B > 0 := by
  have h1 : 0 < 1 - α := by linarith
  have h2 : 0 < πH - πL := by linarith
  have key : p - πL * B = (1 - α) * ((πH - πL) * B) := by linear_combination h_zero_profit
  rw [key]
  exact mul_pos h1 (mul_pos h2 hB_pos)