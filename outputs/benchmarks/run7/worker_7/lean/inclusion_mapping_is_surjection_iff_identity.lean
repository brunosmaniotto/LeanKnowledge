import Mathlib

open Set

variable {T : Type _} (S : Set T)

theorem inclusion_surjective_iff_set_eq_univ :
    Function.Surjective (fun (s : S) => (s : T)) ↔ S = Set.univ := by
  constructor
  · intro h
    ext t
    constructor
    · intro _
      exact Set.mem_univ t
    · intro _
      obtain ⟨s, rfl⟩ := h t
      exact s.2
  · intro h
    intro t
    have : t ∈ S := by rw [h]; exact Set.mem_univ t
    exact ⟨⟨t, this⟩, rfl⟩