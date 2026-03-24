import Mathlib

/-- The identity mapping is an order isomorphism from an ordered set to itself. -/
theorem identity_is_order_iso (α : Type _) [LE α] : ∃ (f : α ≃o α), ∀ x : α, f x = x := by
  refine ⟨OrderIso.refl α, λ _ => rfl⟩