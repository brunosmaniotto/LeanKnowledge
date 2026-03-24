import Mathlib

/-- The interest rate implicit in a proportional price sequence with factor α.
    Given p_t = α · p_{t-1}, we have p_t = (1 + r) · p_{t+1}, where r = (1 - α) / α. -/
noncomputable def implicitInterestRate (α : ℝ) : ℝ := (1 - α) / α