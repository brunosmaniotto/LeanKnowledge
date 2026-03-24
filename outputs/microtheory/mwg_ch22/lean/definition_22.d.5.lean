import Mathlib

def NoInterpersonalComparisons (I X R : Type*) (F : (I → X → ℝ) → R) : Prop :=
  ∀ (u u' : I → X → ℝ) (β α : I → ℝ),
    (∀ i, β i > 0) → (∀ i x, u' i x = β i * u i x + α i) → F u = F u'