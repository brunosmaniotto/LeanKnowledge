import Mathlib

open Set

variable {α : Type*} [TopologicalSpace α] {I : Type*} (H : I → Set α)

theorem closure_iInter_subset_iInter_closure : closure (⋂ i, H i) ⊆ ⋂ i, closure (H i) := by
  intro x hx
  simp only [mem_iInter]
  intro i
  exact closure_mono (iInter_subset H i) hx