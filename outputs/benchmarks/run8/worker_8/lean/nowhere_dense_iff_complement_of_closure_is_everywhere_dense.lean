import Mathlib

open Set

variable {α : Type*} [TopologicalSpace α] {H : Set α}

theorem isNowhereDense_iff_compl_closure_dense : IsNowhereDense H ↔ Dense ((closure H)ᶜ) := by
  rw [dense_iff_closure_eq, closure_compl, compl_univ_iff]
  rfl