import Mathlib

/-- A competitive equilibrium where the firm supplies on its marginal cost curve
    and the market clears at the intersection of demand and marginal cost. -/
structure CompetitiveEquilibrium where
  /-- Marginal cost function -/
  mc : ℝ → ℝ
  /-- Average variable cost function -/
  avc : ℝ → ℝ
  /-- Marshallian demand as a function of price and income -/
  demand : ℝ → ℝ → ℝ
  /-- Consumer income -/
  y₀ : ℝ
  /-- Equilibrium quantity -/
  q_star : ℝ
  /-- Equilibrium price -/
  p_star : ℝ
  /-- Firm optimality: price equals marginal cost -/
  price_eq_mc : p_star = mc q_star
  /-- Participation: price covers average variable cost -/
  price_ge_avc : p_star ≥ avc q_star
  /-- Market clearing: demand equals supply -/
  market_clearing : demand p_star y₀ = q_star

/-- The competitive equilibrium price-quantity pair lies on both the demand curve
    and the marginal cost curve. -/
theorem Claim_4_3_2_b (eq : CompetitiveEquilibrium) :
    eq.p_star = eq.mc eq.q_star ∧
    eq.demand eq.p_star eq.y₀ = eq.q_star ∧
    eq.p_star ≥ eq.avc eq.q_star :=
  ⟨eq.price_eq_mc, eq.market_clearing, eq.price_ge_avc⟩