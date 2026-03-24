import Mathlib

variable {S T : Type}

theorem image_subset_of_subset (R : Set (S × T)) (A B : Set S) (hAB : A ⊆ B) :
    { t : T | ∃ s ∈ A, (s, t) ∈ R } ⊆ { t : T | ∃ s ∈ B, (s, t) ∈ R } := by
  intro t ht
  rcases ht with ⟨s, hsA, hst⟩
  exact ⟨s, hAB hsA, hst⟩