import Mathlib

theorem restriction_to_image_surjective {S T : Type _} (f : S → T) :
    Function.Surjective (fun s : S => ⟨f s, ⟨s, rfl⟩⟩ : S → Set.range f) := by
  intro y
  rcases y with ⟨y_val, ⟨s, h⟩⟩
  exact ⟨s, Subtype.ext h⟩