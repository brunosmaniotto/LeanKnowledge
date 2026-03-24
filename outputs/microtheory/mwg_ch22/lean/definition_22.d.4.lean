import Mathlib

def InvariantToCommonCardinalTransformations
    {X : Type*} {ι : Type*} {R : Type*}
    (F : (ι → X → ℝ) → R) : Prop :=
  ∀ (u : ι → X → ℝ) (β α : ℝ), β > 0 →
    F (fun i x => β * u i x + α) = F u