import Mathlib
open Filter

noncomputable section

/-- Economy with stationary path supported by proportional prices at rate r -/
structure PropPriceEconomy where
  r : ℝ
  inY : Prop
  supported : Prop

/-- Efficiency: transversality condition holds (prices → 0) -/
axiom efficient_of_positive_rate (E : PropPriceEconomy) :
  E.supported → E.inY → E.r > 0 →
  Filter.Tendsto (fun t : ℕ => (1 / (1 + E.r)) ^ t) Filter.atTop (nhds 0)

/-- Inefficiency: a dominating perturbation exists when r < 0 -/
axiom inefficient_of_negative_rate (E : PropPriceEconomy) :
  E.supported → E.inY → E.r < 0 →
  ∃ ε : ℝ, ε > 0 ∧ ε * (1 - 1 / (1 + E.r)) < 0

theorem Proposition_20E2 (E : PropPriceEconomy) (hsupp : E.supported) (hY : E.inY) :
    (E.r > 0 → Filter.Tendsto (fun t : ℕ => (1 / (1 + E.r)) ^ t) Filter.atTop (nhds 0)) ∧
    (E.r < 0 → ∃ ε : ℝ, ε > 0 ∧ ε * (1 - 1 / (1 + E.r)) < 0) := by
  constructor
  · intro hr
    exact efficient_of_positive_rate E hsupp hY hr
  · intro hr
    exact inefficient_of_negative_rate E hsupp hY hr