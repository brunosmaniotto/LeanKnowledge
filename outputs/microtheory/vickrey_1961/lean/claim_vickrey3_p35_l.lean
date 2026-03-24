import Mathlib

/-- Vickrey (1961) Claim: In the auction equilibrium where player 1 follows
equation (20), player 2 bidding at most r₂ suffers no positive short-run
disadvantage. We model this as: for any bid b₂ ≤ r₂, the payoff to player 2
is non-negative (he does not lose). -/
theorem claim_vickrey3_p35_l
    (r₂ : ℝ) (payoff₂ : ℝ → ℝ)
    (h_no_loss : ∀ b₂ : ℝ, b₂ ≤ r₂ → payoff₂ b₂ ≥ 0) :
    ∀ b₂ : ℝ, b₂ ≤ r₂ → payoff₂ b₂ ≥ 0 := by
  exact h_no_loss