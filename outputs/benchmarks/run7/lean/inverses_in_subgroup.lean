import Mathlib

variable {G : Type _} [Group G] (H : Subgroup G)

theorem inv_in_subgroup_eq_inv_in_group (h : H) : (h⁻¹ : G) = (h : G)⁻¹ := rfl