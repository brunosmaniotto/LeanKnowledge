import Mathlib

theorem direct_image_surjective {S T : Type*} (f : S → T) (hf : Function.Surjective f) :
    Function.Surjective (Set.image f) := by
  intro Y
  refine ⟨f ⁻¹' Y, ?_⟩
  ext y
  constructor
  · intro h
    rcases h with ⟨x, hx, rfl⟩
    exact hx
  · intro hy
    rcases hf y with ⟨x, rfl⟩
    exact ⟨x, hy, rfl⟩