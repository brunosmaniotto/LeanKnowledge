import Mathlib

noncomputable section

def StrictlyQuasiconcave {X : Type*} [AddCommMonoid X] [Module ℝ X] (u : X → ℝ) : Prop :=
  ∀ x y : X, x ≠ y → ∀ t : ℝ, u x ≥ t → u y ≥ t →
    u ((1/2 : ℝ) • x + (1/2 : ℝ) • y) > t