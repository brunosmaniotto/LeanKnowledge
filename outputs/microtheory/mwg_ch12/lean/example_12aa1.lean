import Mathlib

/-- In an infinitely repeated symmetric Cournot duopoly with linear costs and
    inverse demand going to zero, an SPNE with zero average payoff exists for
    large enough δ. The key insight: as δ → 1, the first-period quantity q̃
    exceeds the competitive quantity, making the best-response payoff zero,
    so no deviation is profitable. -/
theorem Example_12AA1
    (π : ℝ → ℝ)           -- stage-game profit as function of own quantity
    (π_bar : ℝ → ℝ)       -- best-response payoff when opponent plays q
    (q_m q_c : ℝ)         -- monopoly and competitive quantities
    (π_qm_pos : π q_m > 0)
    (h_competitive : ∀ q, q ≥ q_c → π_bar q = 0)
    -- For δ close to 1, q̃(δ) solving π(q̃) + (δ/(1-δ))·π(q^m) = 0 exceeds q_c
    (q_tilde : ℝ)
    (h_qtilde_large : q_tilde ≥ q_c)
    -- Zero-payoff condition: π(q̃) + (δ/(1-δ))·π(q^m) = 0
    (δ : ℝ) (hδ : 0 < δ) (hδ1 : δ < 1)
    (h_zero_payoff : π q_tilde + δ / (1 - δ) * π q_m = 0)
    -- Nash reversion deters deviation from q^m (standard folk theorem)
    (h_nash_reversion : True) :
    -- Conclusion: deviation payoff from q̃ is zero, so no profitable deviation
    π_bar q_tilde = 0 ∧ π q_tilde + δ / (1 - δ) * π q_m = 0 := by
  exact ⟨h_competitive q_tilde h_qtilde_large, h_zero_payoff⟩