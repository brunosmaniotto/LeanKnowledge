import Mathlib

lemma self_iff_not_self_is_false {α : Type*} (S : Set α) (x : α) : ¬(x ∈ S ↔ ¬x ∈ S) := by
  simp