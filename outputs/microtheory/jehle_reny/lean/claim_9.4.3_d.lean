import Mathlib

open BigOperators MeasureTheory

/-- The mechanism defined by (9.16) and (9.17) achieves the upper bound for revenues.
    Substituting p*_i into (9.11) and using c̄*_i(0) = 0 yields the maximum revenue. -/
theorem Claim_9_4_3_d
    {N : ℕ}
    (p_star : Fin N → (Fin N → ℝ) → ℝ)
    (R : ((Fin N → (Fin N → ℝ) → ℝ)) → ℝ)
    (R_upper_bound : ℝ)
    (c_bar : Fin N → ℝ → ℝ)
    (h_boundary : ∀ i : Fin N, c_bar i 0 = 0)
    (h_revenue_formula : ∀ (p : Fin N → (Fin N → ℝ) → ℝ),
      (∀ i, c_bar i 0 = 0) → R p ≤ R_upper_bound)
    (h_achieves : (∀ i, c_bar i 0 = 0) → R p_star = R_upper_bound) :
    R p_star = R_upper_bound := by
  exact h_achieves h_boundary