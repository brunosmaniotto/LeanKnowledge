import Mathlib

/-- The preference-maximizing choice rule C*(B, ≿).
    Given a relation `ge` (≿) on `X` and a subset `B ⊆ X`,
    returns {x ∈ B | ∀ y ∈ B, x ≿ y}. -/
def preferenceMaximizingChoice {X : Type*} (ge : X → X → Prop) (B : Set X) : Set X :=
  {x ∈ B | ∀ y ∈ B, ge x y}