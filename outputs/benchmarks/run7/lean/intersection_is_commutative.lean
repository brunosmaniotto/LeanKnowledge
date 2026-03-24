import Mathlib

theorem intersection_comm {α : Type*} (S T : Set α) : S ∩ T = T ∩ S := by
  ext x
  simp [and_comm]