import Mathlib
open Set

theorem reflexive_equiv (α : Type*) (S : Set α) (r : Set (α × α)) :
    (∀ x, x ∈ S → (x, x) ∈ r) ↔ (diagonal α ∩ (S ×ˢ S)) ⊆ r := by
  constructor
  · intro h p hp
    rcases hp with ⟨hp_diag, hp_prod⟩
    rcases mem_prod.1 hp_prod with ⟨hx, hy⟩
    have h_eq : p.1 = p.2 := by
      simpa [mem_diagonal_iff] using hp_diag
    -- Rewrite p as (p.1, p.1) using the equality of components
    have : p = (p.1, p.1) := by
      ext <;> simp [h_eq]
    rw [this]
    exact h p.1 hx
  · intro h x hx
    have h1 : (x, x) ∈ diagonal α := by
      simp
    have h2 : (x, x) ∈ S ×ˢ S := by
      simp [hx]
    exact h ⟨h1, h2⟩