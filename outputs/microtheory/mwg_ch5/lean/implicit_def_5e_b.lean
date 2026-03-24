import Mathlib
open BigOperators

/-- A production set: all feasible production plans for a firm. -/
abbrev ProductionSet (L : ℕ) := Set (Fin L → ℝ)

/-- The aggregate production set Y = Y₁ + ⋯ + Y_J is the Minkowski sum of J firms'
    production sets. A vector y is in Y iff it can be decomposed as y = ∑ⱼ yⱼ
    with each yⱼ ∈ Yⱼ. -/
def aggregateProductionSet {L : ℕ} {J : ℕ} (Y : Fin J → ProductionSet L) :
    ProductionSet L :=
  {y | ∃ yf : Fin J → (Fin L → ℝ), (∀ j, yf j ∈ Y j) ∧ y = ∑ j, yf j}

/-- The profit function of the aggregate production set:
    π*(p) = sup { p · y : y ∈ Y }. -/
noncomputable def aggregateProfitFunction {L : ℕ} {J : ℕ}
    (Y : Fin J → ProductionSet L) (p : Fin L → ℝ) : EReal :=
  ⨆ y ∈ aggregateProductionSet Y, (↑(∑ i, p i * y i) : EReal)

/-- The supply correspondence of the aggregate production set:
    y*(p) = { y ∈ Y : p · y = π*(p) }. -/
noncomputable def aggregateSupplyCorrespondence {L : ℕ} {J : ℕ}
    (Y : Fin J → ProductionSet L) (p : Fin L → ℝ) : Set (Fin L → ℝ) :=
  {y ∈ aggregateProductionSet Y |
    (↑(∑ i, p i * y i) : EReal) = aggregateProfitFunction Y p}