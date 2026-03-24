import Mathlib

theorem set_union_preserves_subsets {α : Type} {A B S T : Set α} (hAB : A ⊆ B) (hST : S ⊆ T) : A ∪ S ⊆ B ∪ T := by
  intro x hx
  rcases hx with (hx | hx)
  · exact Or.inl (hAB hx)
  · exact Or.inr (hST hx)