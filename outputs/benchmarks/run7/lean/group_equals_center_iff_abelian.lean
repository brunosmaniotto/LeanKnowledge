import Mathlib

theorem center_eq_top_iff_commutative (G : Type*) [Group G] :
    Subgroup.center G = ⊤ ↔ ∀ x y : G, x * y = y * x := by
  constructor
  · intro h x y
    have hx : x ∈ Subgroup.center G := by
      rw [h]
      exact Subgroup.mem_top x
    rw [Subgroup.mem_center_iff] at hx
    exact (hx y).symm
  · intro h
    ext a
    constructor
    · intro ha
      exact Subgroup.mem_top a
    · intro ha
      rw [Subgroup.mem_center_iff]
      intro g
      exact (h a g).symm