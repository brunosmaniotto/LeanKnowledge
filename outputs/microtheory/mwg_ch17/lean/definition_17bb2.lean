import Mathlib
open BigOperators

/-- The cheaper consumption condition for consumer i in a Walrasian quasiequilibrium.
    Given price vector p, endowment ω_i, consumption set X_i, production plans y*,
    and profit shares θ_i, consumer i satisfies this condition if there exists
    some affordable consumption bundle strictly cheaper than their wealth. -/
def cheaperConsumptionCondition
    {L : Type*} [Fintype L] {J : Type*} [Fintype J]
    (p : L → ℝ) (ω_i : L → ℝ) (X_i : Set (L → ℝ))
    (θ_i : J → ℝ) (yStar : J → (L → ℝ)) : Prop :=
  ∃ x_i ∈ X_i,
    ∑ l : L, p l * x_i l <
      ∑ l : L, p l * ω_i l + ∑ j : J, θ_i j * ∑ l : L, p l * yStar j l