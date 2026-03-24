import Mathlib

/-- Adverse selection causes market breakdown: under uniform risk types θ ∈ [0,1] with
    loss L > 0, the competitive break-even condition p = (p + L)/2 forces p* = L.
    At p* = L, any agent with risk θ < 1 has expected loss θ·L < L = p*, so they
    refuse to buy — mutually beneficial trades fail to occur. -/
theorem Claim_8_1_1_r (L : ℝ) (hL : 0 < L) :
    -- Part 1: unique equilibrium price is p* = L
    (∀ p : ℝ, p = (p + L) / 2 → p = L) ∧
    -- Part 2: at p* = L, all types θ < 1 find insurance too expensive (no trade)
    (∀ θ : ℝ, 0 ≤ θ → θ < 1 → θ * L < L) := by
  constructor
  · intro p hp; linarith
  · intro θ _ hθ
    have : (1 - θ) * L > 0 := mul_pos (by linarith) hL
    linarith