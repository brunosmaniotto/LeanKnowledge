import Mathlib

open Set

theorem set_equiv_proper_subset_powerset (α : Type) (S : Set α) :
    ∃ (T : Set (Set α)), T ⊂ 𝒫 S ∧ Nonempty (S ≃ T) := by
  let T : Set (Set α) := {t | ∃ x ∈ S, t = {x}}
  have hT_sub : T ⊆ 𝒫 S := by
    intro t ht
    rcases ht with ⟨x, hx, rfl⟩
    rw [mem_powerset_iff]
    exact singleton_subset_iff.mpr hx
  have h_empty_mem : (∅ : Set α) ∈ 𝒫 S := by
    rw [mem_powerset_iff]
    exact empty_subset S
  have h_empty_not_mem : (∅ : Set α) ∉ T := by
    intro h
    rcases h with ⟨x, hx, h⟩
    have : ({x} : Set α) ≠ ∅ := singleton_ne_empty x
    exact this h.symm
  have h_proper : T ⊂ 𝒫 S := by
    refine ⟨hT_sub, ?_⟩
    intro h
    have h_empty : (∅ : Set α) ∈ T := h h_empty_mem
    exact h_empty_not_mem h_empty
  let f : S → T := fun ⟨x, hx⟩ => ⟨{x}, ⟨x, hx, rfl⟩⟩
  have hinj : Function.Injective f := by
    rintro ⟨x, hx⟩ ⟨y, hy⟩ h
    have h_singleton : ({x} : Set α) = {y} := congr_arg Subtype.val h
    have hxy : x = y := singleton_injective h_singleton
    exact Subtype.ext hxy
  have hsurj : Function.Surjective f := by
    rintro ⟨t, ht⟩
    rcases ht with ⟨x, hx, rfl⟩
    exact ⟨⟨x, hx⟩, rfl⟩
  have h_equiv : Nonempty (S ≃ T) := ⟨Equiv.ofBijective f ⟨hinj, hsurj⟩⟩
  exact ⟨T, h_proper, h_equiv⟩