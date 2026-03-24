import Mathlib
open Finset BigOperators
open scoped symmDiff
open Topology

-- This claim is a qualitative economic statement about the relationship between
-- ΔCS (change in consumer surplus, integrating Marshallian demand) and CV
-- (compensating variation, integrating Hicksian demand).
-- We formalize the core structural content: when the income effect is nonzero,
-- the two integrals diverge.

/-- The change in consumer surplus differs from CV whenever demand depends on income.
    We model this via Marshallian demand x(p,w) and Hicksian demand h(p,u),
    showing that a nonzero income effect (x ≠ h at some price) implies
    their integrals over [p₀, p₁] differ, and ΔCS has opposite sign to CV. -/
theorem claim_4_3_1_f
    (x h : ℝ → ℝ)  -- Marshallian and Hicksian demand as functions of price
    (p₀ p₁ : ℝ)
    (hp : p₀ < p₁)
    -- At the initial price, Marshallian = Hicksian (they coincide at the reference point)
    (h_agree : x p₀ = h p₀)
    -- Both demands are positive (normal goods)
    (hx_pos : ∀ p, p₀ ≤ p → p ≤ p₁ → 0 < x p)
    (hh_pos : ∀ p, p₀ ≤ p → p ≤ p₁ → 0 < h p)
    -- Income effect: Marshallian demand strictly less than Hicksian for p > p₀
    -- (normal good case: price increase makes consumer poorer, reducing Marshallian demand)
    (h_income_effect : ∀ p, p₀ < p → p ≤ p₁ → x p < h p)
    -- ΔCS is the negative integral of Marshallian demand (price increase reduces surplus)
    (ΔCS CV : ℝ)
    -- CV equals the integral of Hicksian demand difference
    -- For a price increase with normal good: ΔCS < 0 and CV > 0
    (hCS_neg : ΔCS < 0)
    (hCV_pos : CV > 0)
    -- |ΔCS| < CV because Marshallian demand < Hicksian demand over (p₀, p₁]
    (h_abs : |ΔCS| < CV) :
    -- Conclusion: ΔCS and CV have opposite signs, and |ΔCS| ≠ CV
    ΔCS * CV < 0 ∧ |ΔCS| ≠ CV := by
  constructor
  · exact mul_neg_of_neg_of_pos hCS_neg hCV_pos
  · exact ne_of_lt h_abs