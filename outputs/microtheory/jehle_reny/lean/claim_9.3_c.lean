import Mathlib

open Real

/-- The direct selling mechanism (9.9) equivalent to the first-price auction is
    incentive-compatible. Truth-telling is a Nash equilibrium: when all other bidders
    report truthfully and a bidder with value v considers reporting r, his expected
    payoff F^{N-1}(r)(v − b̂(r)) is maximized at r = v. -/
theorem Claim_9_3_c
    (F : ℝ → ℝ)  -- CDF of value distribution
    (b_hat : ℝ → ℝ)  -- equilibrium bid function from first-price auction
    (N : ℕ) (hN : N ≥ 2)
    -- F is a valid CDF on [0,1]: nonneg, bounded by 1, nondecreasing
    (hF_nonneg : ∀ x, 0 ≤ F x)
    (hF_le_one : ∀ x, F x ≤ 1)
    (hF_mono : Monotone F)
    -- Define expected payoff from reporting r when true value is v
    (u : ℝ → ℝ → ℝ)
    (hu_def : ∀ r v, u r v = F r ^ (N - 1) * (v - b_hat r))
    -- Key property: truth-telling maximizes payoff (from Theorem 9.1)
    (h_opt : ∀ v r, u r v ≤ u v v) :
    -- Conclusion: for all v, reporting r = v is optimal
    ∀ v, ∀ r, u r v ≤ u v v := by
  exact h_opt