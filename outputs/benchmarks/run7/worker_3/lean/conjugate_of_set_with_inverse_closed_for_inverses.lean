import Mathlib

theorem conjugate_set_inv_closed (G : Type*) [Group G] (S : Set G) :
    ∀ x ∈ {x | ∃ a : G, ∃ s ∈ S ∪ S⁻¹, x = a * s * a⁻¹}, x⁻¹ ∈ {x | ∃ a : G, ∃ s ∈ S ∪ S⁻¹, x = a * s * a⁻¹} := by
  intro x hx
  rcases hx with ⟨a, s, hs, rfl⟩
  have h : s⁻¹ ∈ S ∪ S⁻¹ := by
    rcases hs with (hs | hs)
    · right
      rw [Set.mem_inv]
      rwa [inv_inv]
    · left
      exact Set.mem_inv.1 hs
  refine ⟨a, s⁻¹, h, ?_⟩
  group