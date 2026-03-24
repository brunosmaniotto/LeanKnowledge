import Mathlib

/-- An equilibrium of the insurance screening game where two firms compete. -/
structure InsuranceScreeningEquilibrium where
  profit₁ : ℝ
  profit₂ : ℝ
  /-- Each firm can guarantee zero profit by offering no contracts. -/
  nonneg₁ : 0 ≤ profit₁
  nonneg₂ : 0 ≤ profit₂
  /-- If aggregate profits were positive, a firm could deviate by offering
      slightly better terms to attract all customers, so aggregate ≤ 0. -/
  no_positive_aggregate : profit₁ + profit₂ ≤ 0

theorem Invoked_Lemma_8_2 (E : InsuranceScreeningEquilibrium) :
    E.profit₁ = 0 ∧ E.profit₂ = 0 := by
  constructor <;> linarith [E.nonneg₁, E.nonneg₂, E.no_positive_aggregate]