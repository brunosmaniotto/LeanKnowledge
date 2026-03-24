import Mathlib

variable {S : Type*}

theorem reflexive_iff_complement_antireflexive (r : Set (S × S)) :
    (∀ x, (x, x) ∈ r) ↔ (∀ x, (x, x) ∉ rᶜ) := by
  simp