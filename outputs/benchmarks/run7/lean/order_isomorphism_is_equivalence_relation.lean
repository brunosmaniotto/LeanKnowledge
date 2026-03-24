import Mathlib

open OrderIso

theorem order_iso_equivalence :
    (∀ (α : Type _) [PartialOrder α], Nonempty (α ≃o α)) ∧
    (∀ (α β : Type _) [PartialOrder α] [PartialOrder β], Nonempty (α ≃o β) → Nonempty (β ≃o α)) ∧
    (∀ (α β γ : Type _) [PartialOrder α] [PartialOrder β] [PartialOrder γ],
      Nonempty (α ≃o β) → Nonempty (β ≃o γ) → Nonempty (α ≃o γ)) := by
  refine ⟨?_, ?_, ?_⟩
  · intro α _; exact ⟨OrderIso.refl α⟩
  · intro α β _ _ h; exact h.elim fun e => ⟨e.symm⟩
  · intro α β γ _ _ _ h1 h2
    exact h1.elim fun e1 => h2.elim fun e2 => ⟨e1.trans e2⟩