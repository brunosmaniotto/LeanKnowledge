import Mathlib

/-- The Pareto Indifference Principle (PI): if every individual is indifferent
    between two social states (equal utility), then the social welfare functional
    must rank them as socially indifferent. -/
def ParetoIndifference {N X : Type*}
    (f : (N → X → ℝ) → X → X → Prop) : Prop :=
  ∀ (u : N → X → ℝ) (x y : X),
    (∀ i : N, u i x = u i y) → (f u x y ∧ f u y x)