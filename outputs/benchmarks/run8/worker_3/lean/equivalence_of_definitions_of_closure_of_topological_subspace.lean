import Mathlib

open Set TopologicalSpace

variable {α : Type _} [TopologicalSpace α] (H : Set α)

theorem closure_eq_sInter : closure H = ⋂₀ {F | IsClosed F ∧ H ⊆ F} := by
  apply Subset.antisymm
  · intro x hx
    exact mem_sInter.2 fun F ⟨hF, hHF⟩ => closure_minimal hHF hF hx
  · intro x hx
    have : closure H ∈ {F | IsClosed F ∧ H ⊆ F} := ⟨isClosed_closure, subset_closure⟩
    exact mem_sInter.1 hx _ this