import Mathlib

theorem image_of_element_is_subset (S T : Type) (R : S → T → Prop) (A : Set S) (s : S) (hs : s ∈ A) :
    { t | R s t } ⊆ { t | ∃ a ∈ A, R a t } := by
  intro t ht
  exact ⟨s, hs, ht⟩