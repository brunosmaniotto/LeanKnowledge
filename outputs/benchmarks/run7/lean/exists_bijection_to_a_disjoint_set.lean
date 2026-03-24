import Mathlib

-- Helper lemma: there exists an element not in any given set
lemma exists_not_in_set (β : Type*) (X : Set β) : ∃ z : β ⊕ Unit, z ∉ (Sum.inl '' X) := by
  use Sum.inr ()
  intro h
  simp [Set.mem_image] at h

-- Product with singleton disjoint lemma