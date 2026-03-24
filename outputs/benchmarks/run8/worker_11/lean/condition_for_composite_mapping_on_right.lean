import Mathlib

open Set

theorem exists_function_of_range_subset {A B C : Type _} (f : B → A) (g : C → A) :
    range g ⊆ range f ↔ ∃ h : C → B, f ∘ h = g := by
  constructor
  · intro hsub
    have h : ∀ x, ∃ y, f y = g x := by
      intro x
      have mem : g x ∈ range g := ⟨x, rfl⟩
      exact hsub mem
    choose h' hh' using h
    exact ⟨h', by ext x; exact hh' x⟩
  · rintro ⟨h, rfl⟩ y ⟨x, rfl⟩
    exact ⟨h x, rfl⟩