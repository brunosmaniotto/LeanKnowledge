import Mathlib
set_option linter.unusedVariables false

noncomputable section

/-- The virtual valuation function for a bidder with CDF `F` and PDF `f`. -/
def virtualValuation (F f : ℝ → ℝ) : ℝ → ℝ :=
  fun v => v - (1 - F v) / f v

end