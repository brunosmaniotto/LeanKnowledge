import Mathlib

theorem group_isomorphism_preserves_identity {G H : Type*} [Group G] [Group H] (φ : G ≃* H) : φ 1 = 1 :=
  φ.map_one