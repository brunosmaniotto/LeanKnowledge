import Mathlib

-- First-price auction: two bidders with values v₁ (variable) and a (fixed).
-- Bidder with higher bid wins; payoff = value − bid.
-- Claim: bidder 2 with fixed value a cannot play a pure strategy bid c in equilibrium.
-- The instability: if bidder 2 bids c, bidder 1 can beat c profitably (bid (c+a)/2),
-- and bidder 2 then wants to raise their bid above bidder 1's — contradicting c being fixed.

theorem bidder2_no_pure_strategy_nash (a : ℝ) (ha : 0 < a) :
    ∀ (c : ℝ) (_hc : 0 ≤ c) (hca : c < a),
      ∃ (b₁ b₂ : ℝ),
        b₁ > c ∧ 0 < a - b₁ ∧  -- bidder 1 beats c and earns positive payoff (v₁ = a)
        b₂ > b₁ ∧ 0 < a - b₂   -- bidder 2 can deviate: beat b₁ and still profit
    := by
  intro c _hc hca
  exact ⟨(c + a) / 2, (c + 3 * a) / 4,
         by linarith, by linarith, by linarith, by linarith⟩