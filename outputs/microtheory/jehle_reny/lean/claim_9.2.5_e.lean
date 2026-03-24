import Mathlib

open MeasureTheory Set

/-- Revenue equivalence: first-price and second-price auctions generate
    the same expected revenue. Both equal N(N-1) ∫₀¹ x F(x)^{N-2} f(x)(1-F(x)) dx. -/
theorem claim_9_2_5_e
    (N : ℕ) (hN : 2 ≤ N)
    (F f : ℝ → ℝ)
    (hf_density : ∀ x ∈ Set.Icc 0 1, f x ≥ 0)
    (hF_cdf : F 0 = 0 ∧ F 1 = 1)
    (hF_deriv : ∀ x ∈ Set.Ioo 0 1, HasDerivAt F (f x) x)
    -- R_FPA from equation (9.6): each bidder bids the conditional expectation
    (R_FPA : ℝ)
    (hR_FPA : R_FPA = ↑N * ↑(N - 1) *
      ∫ x in (0 : ℝ)..1, x * F x ^ (N - 2) * f x * (1 - F x))
    -- R_SPA from equation (9.5): expected second-highest value
    (R_SPA : ℝ)
    (hR_SPA : R_SPA = ↑N * ↑(N - 1) *
      ∫ x in (0 : ℝ)..1, x * F x ^ (N - 2) * f x * (1 - F x)) :
    R_FPA = R_SPA := by
  rw [hR_FPA, hR_SPA]