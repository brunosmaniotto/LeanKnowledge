import Mathlib

theorem group_is_subgroup_of_itself (G : Type*) [Group G] : (⊤ : Subgroup G) ≤ (⊤ : Subgroup G) :=
  le_rfl