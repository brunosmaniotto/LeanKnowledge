import Mathlib

/-- A preference relation `pref` on `ℝ≥0^L` is homothetic if indifference is preserved
    under positive scaling: whenever `x ~ y`, we have `αx ~ αy` for all `α > 0`. -/
def IsHomothetic {L : ℕ} (pref : (Fin L → ℝ) → (Fin L → ℝ) → Prop) : Prop :=
  ∀ (x y : Fin L → ℝ), pref x y → pref y x →
    ∀ (α : ℝ), 0 < α → pref (α • x) (α • y) ∧ pref (α • y) (α • x)