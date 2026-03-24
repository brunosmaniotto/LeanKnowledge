import Mathlib

theorem Inverse_of_Generator_of_Cyclic_Group_is_Generator
  (G : Type*) [Group G] (g : G) (h : Subgroup.closure {g} = ⊤) : Subgroup.closure {g⁻¹} = ⊤ := by
  rw [Subgroup.closure_singleton_inv]
  exact h