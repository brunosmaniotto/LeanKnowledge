import Mathlib

open scoped BigOperators
open BigOperators

/-- A consumption bundle is a vector in ℝ²₊ (represented as Fin 2 → ℝ) -/
abbrev ConsumptionBundle := Fin 2 → ℝ

/-- An allocation assigns a consumption bundle to each of 2 consumers -/
abbrev Allocation := Fin 2 → ConsumptionBundle

/-- Dot product of two 2-dimensional vectors -/
noncomputable def dot2 (p x : Fin 2 → ℝ) : ℝ := ∑ j : Fin 2, p j * x j

/-- Definition 15.B.3: An allocation x* is supportable as an equilibrium with transfers
    if there exists a price system p* and balanced transfers (T₁ + T₂ = 0) such that
    for each consumer i, x*_i is weakly preferred to every affordable bundle under
    the transferred wealth. -/
def SupportableAsEquilibriumWithTransfers
    (pref : Fin 2 → ConsumptionBundle → ConsumptionBundle → Prop)
    (ω : Allocation)
    (xStar : Allocation) : Prop :=
  ∃ (price : ConsumptionBundle) (transfer : Fin 2 → ℝ),
    transfer 0 + transfer 1 = 0 ∧
    ∀ (i : Fin 2) (x_i : ConsumptionBundle),
      (∀ j, 0 ≤ x_i j) →
      dot2 price x_i ≤ dot2 price (ω i) + transfer i →
      pref i (xStar i) x_i