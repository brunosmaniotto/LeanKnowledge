import Mathlib

variable {G : Type*} [Group G] (H : Subgroup G)

theorem normal_iff_normalizer_eq_top : H.Normal ↔ H.normalizer = ⊤ := by
  exact?