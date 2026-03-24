import Mathlib
open BigOperators

/-- When individual wealth levels are determined by a wealth distribution rule,
    aggregate demand depends only on prices and aggregate wealth. -/
theorem aggregate_demand_under_wealth_distribution
    {P W X : Type*} [AddCommMonoid X]
    {J : Type*} [Fintype J]
    (x_i : J → P → W → X)
    (w_i : J → P → W → W) :
    ∃ x : P → W → X, ∀ p w,
      x p w = ∑ i : J, x_i i p (w_i i p w) := by
  exact ⟨fun p w => ∑ i : J, x_i i p (w_i i p w), fun _ _ => rfl⟩