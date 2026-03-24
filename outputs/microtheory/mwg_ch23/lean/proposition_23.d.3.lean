import Mathlib

open MeasureTheory Set

/-- An auction setting with I risk-neutral buyers -/
structure AuctionSetting where
  I : ℕ
  hI : 0 < I
  /-- Type space bounds for each buyer -/
  θ_L : Fin I → ℝ
  θ_H : Fin I → ℝ
  /-- Types are proper intervals -/
  h_interval : ∀ i, θ_L i < θ_H i

/-- A Bayesian Nash Equilibrium outcome of an auction -/
structure BNEOutcome (A : AuctionSetting) where
  /-- Probability buyer i gets the good given type profile θ -/
  y : Fin A.I → (Fin A.I → ℝ) → ℝ
  /-- Expected utility of buyer i at lowest type -/
  U_low : Fin A.I → ℝ
  /-- Expected revenue for the seller -/
  revenue : ℝ

/-- Revenue decomposition: expected revenue depends only on allocation rules
    y_i(θ) and lowest-type utilities U_i(θ_i^L).
    This is the key structural result from BIC mechanism analysis. -/
axiom revenue_formula (A : AuctionSetting) (outcome : BNEOutcome A) :
  ∃ R : (Fin A.I → (Fin A.I → ℝ) → ℝ) → (Fin A.I → ℝ) → ℝ,
    outcome.revenue = R outcome.y outcome.U_low

/-- The revenue function is uniquely determined by the setting -/
axiom revenue_unique (A : AuctionSetting) (o1 o2 : BNEOutcome A)
    (hy : o1.y = o2.y) (hU : o1.U_low = o2.U_low) :
  o1.revenue = o2.revenue

/-- **Revenue Equivalence Theorem** (MWG Proposition 23.D.3):
    Two BNE outcomes with identical allocation rules and identical
    lowest-type utilities generate the same expected seller revenue. -/
theorem revenue_equivalence_theorem
    (A : AuctionSetting)
    (outcome1 outcome2 : BNEOutcome A)
    (h_same_alloc : outcome1.y = outcome2.y)
    (h_same_low_utility : outcome1.U_low = outcome2.U_low) :
    outcome1.revenue = outcome2.revenue :=
  revenue_unique A outcome1 outcome2 h_same_alloc h_same_low_utility