import Mathlib

/-- A bargaining solution `f` is independent of utility units (IUU) if for any
positive scaling vector `β`, rescaling every utility profile in `U` by `β`
rescales the solution value componentwise by the same `β`. -/
def IsIndependentOfUtilityUnits
    {I : Type*} [Fintype I]
    (f : Set (I → ℝ) → (I → ℝ))
    : Prop :=
  ∀ (U : Set (I → ℝ)) (β : I → ℝ),
    (∀ i, 0 < β i) →
    let U' := { u' : I → ℝ | ∃ u ∈ U, ∀ i, u' i = β i * u i }
    ∀ i, f U' i = β i * f U i