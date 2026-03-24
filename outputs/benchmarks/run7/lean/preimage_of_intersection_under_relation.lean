import Mathlib

variable {S T : Type}
variable (R : Set (S × T))
variable (C D : Set T)

theorem preimage_inter_subset_inter_preimage :
    {x : S | ∃ y ∈ C ∩ D, (x, y) ∈ R} ⊆ {x | ∃ y ∈ C, (x, y) ∈ R} ∩ {x | ∃ y ∈ D, (x, y) ∈ R} := by
  intro x hx
  rcases hx with ⟨y, ⟨hyC, hyD⟩, hxy⟩
  exact ⟨⟨y, hyC, hxy⟩, ⟨y, hyD, hxy⟩⟩