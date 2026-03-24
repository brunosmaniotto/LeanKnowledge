import Mathlib
open MeasureTheory

noncomputable section

/-- In a two-firm competitive market, the second-order conditions for maximizing
    total surplus W = ∫P - C₁ - C₂ require P'(Q) - Cᵢ''(qᵢ) < 0.
    Downward-sloping demand (P' < 0) and rising marginal costs (Cᵢ'' > 0) ensure this. -/
theorem Exercise_4_24
    (P : ℝ → ℝ) (C1 C2 : ℝ → ℝ) (q1 q2 : ℝ)
    (h_demand : deriv P (q1 + q2) < 0)
    (hC1_rising : deriv (deriv C1) q1 > 0)
    (hC2_rising : deriv (deriv C2) q2 > 0)
    : deriv P (q1 + q2) - deriv (deriv C1) q1 < 0
    ∧ deriv P (q1 + q2) - deriv (deriv C2) q2 < 0 := by
  exact ⟨by linarith, by linarith⟩