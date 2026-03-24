import Mathlib

-- Sub-lemmas
lemma surjection_to_range {S T : Type*} (f : S → T) : 
  Function.Surjective (fun x => ⟨f x, x, rfl⟩ : S → Set.range f) := by
  intro ⟨y, x, hx⟩
  use x
  simp [hx]