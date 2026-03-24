import Mathlib

open Set
open Topology

variable {α : Type*} [TopologicalSpace α]

theorem claim_A1_3_g (s : Set α) :
    (IsOpen s ↔ s ∩ frontier s = ∅) ∧
    (IsClosed s ↔ frontier s ⊆ s) := by
  constructor
  · constructor
    · exact IsOpen.inter_frontier_eq
    · intro h
      rw [← interior_eq_iff_isOpen]
      apply subset_antisymm interior_subset
      intro x hx
      by_contra hxi
      have hxf : x ∈ frontier s := by
        constructor
        · exact subset_closure hx
        · exact hxi
      have : x ∈ s ∩ frontier s := ⟨hx, hxf⟩
      rw [h] at this
      exact this
  · constructor
    · exact IsClosed.frontier_subset
    · intro h
      rw [← closure_eq_iff_isClosed]
      apply subset_antisymm _ subset_closure
      intro x hx
      by_contra hxs
      have hxf : x ∈ frontier s := by
        constructor
        · exact hx
        · intro hxi
          exact hxs (interior_subset hxi)
      exact hxs (h hxf)