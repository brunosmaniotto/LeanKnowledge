import Mathlib

-- Model the competitive equilibrium result from MWG Proposition 13.B.1
-- In a competitive equilibrium with adverse selection:
-- - Firms' rational expectations: μ = E[θ | θ ∈ Θ*]
-- - Market clearing with positive employment: w = μ
-- Therefore: w = E[θ | θ ∈ Θ*]

theorem Claim_13B_b
    (w μ E_theta : ℝ)
    (rational_expectations : μ = E_theta)
    (market_clearing : w = μ) :
    w = E_theta := by
  linarith