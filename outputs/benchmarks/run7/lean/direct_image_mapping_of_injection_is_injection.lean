import Mathlib

theorem direct_image_injective {S T : Type*} (f : S → T) (hf : Function.Injective f) :
    Function.Injective (Set.image f) := by
  intro X Y h
  apply Set.ext
  intro x
  constructor
  · intro hx
    have hmem : f x ∈ Set.image f X := ⟨x, hx, rfl⟩
    rw [h] at hmem
    rcases hmem with ⟨y, hy, hfy⟩
    have : y = x := hf hfy
    subst y
    exact hy
  · intro hx
    have hmem : f x ∈ Set.image f Y := ⟨x, hx, rfl⟩
    rw [← h] at hmem
    rcases hmem with ⟨y, hy, hfy⟩
    have : y = x := hf hfy
    subst y
    exact hy