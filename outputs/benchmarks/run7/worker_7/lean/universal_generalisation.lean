import Mathlib

theorem universal_generalization {α : Type} (P : α → Prop) : (∀ a, P a) → ∀ x, P x := by
  intro h x
  exact h x