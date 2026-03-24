import Mathlib

open Set

variable {S : Type*}

theorem set_diff_eq_inter_compl (A B : Set S) : A \ B = A ∩ Bᶜ := by
  ext x
  constructor
  · intro h
    exact ⟨h.1, h.2⟩
  · intro h
    exact ⟨h.1, h.2⟩