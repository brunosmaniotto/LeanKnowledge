import Mathlib
open Set

variable {G : Type _} [Group G] (H : Subgroup G)

theorem Subgroup.normal_iff_union_conjugates :
    H.Normal ↔ (H : Set G) = ⋃ (x ∈ H), {y | ∃ (g : G), y = g * x * g⁻¹} := by
  constructor
  · intro hN
    ext y
    constructor
    · intro hy
      refine mem_iUnion₂.mpr ⟨y, hy, ?_⟩
      exact ⟨1, by simp⟩
    · intro hy
      rw [mem_iUnion₂] at hy
      rcases hy with ⟨x, hx, g, rfl⟩
      exact hN.conj_mem x hx g
  · intro hH
    refine ⟨fun x hx g => ?_⟩
    have mem_union : g * x * g⁻¹ ∈ ⋃ (x ∈ H), {y | ∃ (g : G), y = g * x * g⁻¹} :=
      mem_iUnion₂.mpr ⟨x, hx, g, rfl⟩
    rw [← hH] at mem_union
    exact mem_union