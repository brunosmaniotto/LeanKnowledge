import Mathlib

theorem image_inter_of_injective {S T : Type*} (f : S → T) (hf : Function.Injective f) (A B : Set S) :
    f '' (A ∩ B) = f '' A ∩ f '' B := by
  ext y
  constructor
  · intro h
    rcases h with ⟨x, hx, rfl⟩
    have ⟨hxA, hxB⟩ := hx
    exact ⟨⟨x, hxA, rfl⟩, ⟨x, hxB, rfl⟩⟩
  · intro h
    rcases h with ⟨⟨x, hx, rfl⟩, ⟨x', hx', hx''⟩⟩
    have h_eq : x' = x := hf hx''
    have : x ∈ B := by rwa [h_eq] at hx'
    exact ⟨x, ⟨hx, this⟩, rfl⟩