import Mathlib
open MeasureTheory
set_option linter.unusedVariables false

/-- F(a) = -a^2 * (1 - a) * exp(2 / (2 - a)) * ∫_{a/2}^{1} [u / (1 - u)] * exp(-1/u) du -/
noncomputable def vickrey_F (a : ℝ) : ℝ :=
  -(a ^ 2 * (1 - a) * Real.exp (2 / (2 - a)) *
    ∫ u in Set.Icc (a / 2) 1, (u / (1 - u)) * Real.exp (-1 / u))

/-- Table 3, p.38 Vickrey (1961): structural identity for the summary table of average
    auction expectations. Column definitions:
      sellerReceipts = payment₁ + payment₂         (column 3 = column 1 + 2)
      totalValue     = sellerReceipts + netGain₁ + netGain₂  (column 6 = 3 + 4 + 5)
    The table identity asserts: totalValue = payment₁ + payment₂ + netGain₁ + netGain₂. -/
theorem Table_Vickrey3_p38_Summary
    (payment₁ payment₂ netGain₁ netGain₂ : ℝ) :
    let sellerReceipts := payment₁ + payment₂
    let totalValue := sellerReceipts + netGain₁ + netGain₂
    totalValue = payment₁ + payment₂ + netGain₁ + netGain₂ := by
  ring