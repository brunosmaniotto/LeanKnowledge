import Mathlib

open Set

theorem antireflexive_iff_inter_diagonal_empty {S : Type*} (R : Set (S × S)) :
    (∀ x, (x, x) ∉ R) ↔ Set.diagonal S ∩ R = ∅ := by
  constructor
  · intro h
    ext ⟨x, y⟩
    simp [Set.mem_inter_iff, Set.mem_diagonal_iff]
    intro h_eq h_R
    subst h_eq
    exact h x h_R
  · intro h x hx
    have : (x, x) ∈ Set.diagonal S ∩ R := ⟨Set.mem_diagonal x, hx⟩
    simpa [h] using this