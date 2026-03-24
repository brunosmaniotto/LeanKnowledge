import Mathlib

open Set

variable {X : Type*} [TopologicalSpace X] (A : Set X)

theorem Claim_M_F_b : IsClosed A ↔ frontier A ⊆ A := by
  constructor
  · intro hA
    calc frontier A ⊆ closure A := frontier_subset_closure
    _ = A := hA.closure_eq
    _ ⊆ A := Subset.rfl
  · intro hf
    rw [← closure_eq_iff_isClosed]
    apply Subset.antisymm _ subset_closure
    intro x hx
    by_contra hxA
    have hx_frontier : x ∈ frontier A := by
      constructor
      · exact hx
      · intro hxi
        exact hxA (interior_subset hxi)
    exact hxA (hf hx_frontier)