import Mathlib

theorem intersection_with_universe {α : Type*} (S : Set α) : Set.univ ∩ S = S := by
  simp