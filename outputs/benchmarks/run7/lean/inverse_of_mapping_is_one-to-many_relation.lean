import Mathlib.Data.Set.Function

open Set

theorem inverse_of_mapping_is_one_to_many (f : α → β) :
    ∀ y, y ∈ range f → ∃ x, (fun (y : β) (x : α) => f x = y) y x := by
  intro y h
  rcases h with ⟨x, rfl⟩
  exact ⟨x, rfl⟩