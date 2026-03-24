import Mathlib

open scoped Real
open MeasureTheory

/-- In the Cournot oligopoly with inverse demand p = a - bq, J identical firms
    each with marginal cost c, and each firm producing q/J, total surplus
    W(q) = ∫₀^q (a - bξ)dξ - J · ∫₀^{q/J} c dξ reduces to aq - (b/2)q² - cq. -/
theorem Example_4_4 (a b c q : ℝ) (J : ℝ) (hJ : J ≠ 0) :
    (a * q - b / 2 * q ^ 2) - J * (c * (q / J)) = a * q - b / 2 * q ^ 2 - c * q := by
  field_simp