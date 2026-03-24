import Mathlib

theorem existential_instantiation {α : Sort _} (P : α → Prop) (y : Prop) (h_exists : ∃ x, P x) (h_imp : ∀ a, P a → y) : y := by
  rcases h_exists with ⟨x, hx⟩
  exact h_imp x hx