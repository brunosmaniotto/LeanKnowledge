import Mathlib

open Set
open scoped Pointwise

theorem subset_product_subset_generator (G : Type*) [Group G] (X Y : Set G) :
    X * Y ⊆ Subgroup.closure (X ∪ Y) := by
  intro z hz
  rcases hz with ⟨x, hx, y, hy, rfl⟩
  apply Subgroup.mul_mem
  · exact Subgroup.subset_closure (Set.mem_union_left Y hx)
  · exact Subgroup.subset_closure (Set.mem_union_right X hy)