import Mathlib

/-- A social welfare function is utility-percentage invariant if scaling all individuals'
    utility functions by a common positive factor does not change the social ordering.
    That is, f(u₁, …, uₙ) = f(b·u₁, …, b·uₙ) for all b > 0. -/
def IsUtilityPercentageInvariant
    {I : Type*} {X : Type*} {R : Type*}
    (f : (I → X → ℝ) → R) : Prop :=
  ∀ (u : I → X → ℝ) (b : ℝ), b > 0 →
    f (fun i x => b * u i x) = f u