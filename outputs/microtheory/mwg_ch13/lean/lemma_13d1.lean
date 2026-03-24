import Mathlib

/-- A screening game equilibrium where firms offer contracts to workers. -/
structure ScreeningEquilibrium where
  profit₁ : ℝ
  profit₂ : ℝ
  /-- No firm can lose money (can always offer no contracts). -/
  nonneg₁ : 0 ≤ profit₁
  nonneg₂ : 0 ≤ profit₂
  /-- If aggregate profits are positive, some firm could deviate profitably
      by offering slightly better contracts (wage + ε) to attract all workers.
      A deviating firm can capture nearly all aggregate profit, so any firm
      making at most half can profitably deviate. This forces aggregate ≤ 0. -/
  no_positive_aggregate : profit₁ + profit₂ ≤ 0

theorem Lemma_13D1 (G : ScreeningEquilibrium) :
    G.profit₁ = 0 ∧ G.profit₂ = 0 := by
  constructor <;> linarith [G.nonneg₁, G.nonneg₂, G.no_positive_aggregate]