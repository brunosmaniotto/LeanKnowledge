import Mathlib

variable {α : Type*} [DecidableEq α]

theorem Cardinality_Less_One (s : Set α) (a : α) (n : ℕ) 
    (h_finite : s.Finite) (h_mem : a ∈ s) (h_card : s.ncard = n + 1) :
    (s \ {a}).ncard = n := by
  rw [Set.ncard_diff_singleton_of_mem h_mem, h_card]
  simp