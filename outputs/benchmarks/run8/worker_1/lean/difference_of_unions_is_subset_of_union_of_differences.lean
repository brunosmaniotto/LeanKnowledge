import Mathlib

open Set

theorem Difference_of_Unions_is_Subset_of_Union_of_Differences {ι X : Type*} (S T : ι → Set X) :
    (⋃ i, S i) \ (⋃ i, T i) ⊆ ⋃ i, (S i \ T i) := by
  intro x hx
  rcases hx with ⟨hx_left, hx_right⟩
  rcases mem_iUnion.1 hx_left with ⟨i, hi⟩
  have h_not_Ti : x ∉ T i := by
    intro h
    have h_mem : x ∈ ⋃ i, T i := mem_iUnion.2 ⟨i, h⟩
    exact hx_right h_mem
  exact mem_iUnion.2 ⟨i, ⟨hi, h_not_Ti⟩⟩