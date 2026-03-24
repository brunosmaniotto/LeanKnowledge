import Mathlib

theorem image_empty {S T : Type} (r : S → T → Prop) : { y | ∃ x ∈ (∅ : Set S), r x y } = ∅ := by
  ext y
  simp