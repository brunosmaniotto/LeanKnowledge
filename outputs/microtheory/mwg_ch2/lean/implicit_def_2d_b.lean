import Mathlib
open Topology

/-- The price-taking assumption: prices are beyond the influence of the consumer.
    This holds when the consumer's demand for each commodity represents only
    a small fraction of the total market demand for that good. -/
structure PriceTakingAssumption (n : ℕ) where
  /-- Consumer's demand for each commodity -/
  consumerDemand : Fin n → ℝ
  /-- Total market demand for each commodity -/
  totalDemand : Fin n → ℝ
  /-- Total demand is positive for each commodity -/
  totalDemand_pos : ∀ i, 0 < totalDemand i
  /-- Threshold defining "small fraction" -/
  ε : ℝ
  ε_pos : 0 < ε
  ε_lt_one : ε < 1
  /-- The consumer's demand share is bounded by ε for every commodity,
      formalizing that the consumer cannot influence prices -/
  demand_negligible : ∀ i, |consumerDemand i| / totalDemand i ≤ ε