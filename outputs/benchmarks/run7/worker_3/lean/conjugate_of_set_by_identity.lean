import Mathlib

variable {G : Type} [Group G] (S : Set G)

theorem conjugate_by_identity : {y : G | ∃ x ∈ S, y = (1 : G) * x * (1 : G)⁻¹} = S := by
  ext y
  simp