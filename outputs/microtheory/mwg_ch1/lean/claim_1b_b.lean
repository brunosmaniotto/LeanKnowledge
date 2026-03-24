import Mathlib

theorem utility_composition_preserves_preferences
    {X : Type*} (R : X → X → Prop) (u : X → ℝ) (f : ℝ → ℝ)
    (hu : ∀ x y, R x y ↔ u y ≤ u x)
    (hf : StrictMono f) :
    ∀ x y, R x y ↔ f (u y) ≤ f (u x) := by
  intro x y
  rw [hu x y, hf.le_iff_le]