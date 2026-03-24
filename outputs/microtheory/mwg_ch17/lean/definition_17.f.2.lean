import Mathlib

/-- The gross substitute (GS) property for an excess demand function z.
    Given L goods, z maps price vectors to excess demand vectors.
    GS holds if whenever one price increases (others fixed),
    excess demand for every other good strictly increases. -/
def GrossSubstituteProperty {L : ℕ} (z : (Fin L → ℝ) → (Fin L → ℝ)) : Prop :=
  ∀ (p p' : Fin L → ℝ) (ℓ : Fin L),
    (p' ℓ > p ℓ) →
    (∀ k, k ≠ ℓ → p' k = p k) →
    ∀ k, k ≠ ℓ → z p' k > z p k