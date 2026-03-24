import Mathlib
open Topology

/-- In a competitive market, a firm optimally sets its output price equal to the
    prevailing market price. Charging above yields no sales (demand = 0 when
    price exceeds market price, since consumers buy elsewhere). Charging below
    yields no additional benefit since the firm can sell all it desires at the
    market price. The optimal price is therefore exactly the market price. -/
theorem Claim_3_5_a
    (market_price : ℝ)
    (hm : market_price > 0)
    -- Revenue as a function of the firm's chosen price:
    -- If price > market_price, no sales (revenue = 0).
    -- If price ≤ market_price, the firm sells quantity q at market_price
    --   (it cannot benefit from underpricing).
    (q : ℝ) (hq : q > 0)
    (revenue : ℝ → ℝ)
    (h_above : ∀ p, p > market_price → revenue p = 0)
    (h_at_or_below : ∀ p, p ≤ market_price → revenue p = market_price * q) :
    ∀ p, revenue p ≤ revenue market_price := by
  intro p
  by_cases hp : p > market_price
  · rw [h_above p hp, h_at_or_below market_price (le_refl _)]
    positivity
  · push_neg at hp
    rw [h_at_or_below p hp, h_at_or_below market_price (le_refl _)]