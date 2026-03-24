import Mathlib

theorem inter_self (s : Set α) : s ∩ s = s := by
  ext x
  simp [and_self]