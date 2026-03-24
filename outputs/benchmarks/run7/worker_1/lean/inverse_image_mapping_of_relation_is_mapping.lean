import Mathlib

variable {S T : Type}

theorem inverse_image_mapping_is_mapping (R : Set (S × T)) :
    ∃ (f : Set T → Set S), ∀ Y, f Y = {x | ∃ y ∈ Y, (x, y) ∈ R} :=
  ⟨λ Y => {x | ∃ y ∈ Y, (x, y) ∈ R}, λ Y => rfl⟩