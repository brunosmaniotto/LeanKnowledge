import Mathlib

theorem int_add_group_is_infinite_cyclic : IsAddCyclic ℤ ∧ Infinite ℤ := by
  constructor
  · refine ⟨1, ?_⟩
    intro x
    exact ⟨x, by simp⟩
  · exact inferInstance