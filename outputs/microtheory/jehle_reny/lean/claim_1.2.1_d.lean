import Mathlib

/-- For any pair x₁, x₂, exactly one of three mutually exclusive relations holds:
    x₁ ≻ x₂ (strict preference), x₂ ≻ x₁, or x₁ ∼ x₂ (indifference). -/
theorem Claim_1_2_1_d {X : Type*} (pref : X → X → Prop)
    (complete : ∀ x y : X, pref x y ∨ pref y x)
    (x1 x2 : X) :
    (pref x1 x2 ∧ ¬pref x2 x1) ∨
    (pref x2 x1 ∧ ¬pref x1 x2) ∨
    (pref x1 x2 ∧ pref x2 x1) := by
  have := complete x1 x2
  have := complete x2 x1
  tauto