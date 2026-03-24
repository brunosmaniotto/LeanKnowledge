import Mathlib

variable (G : Type*) [Group G]

theorem center_is_normal_and_abelian : (Subgroup.center G).Normal ∧ ∀ (x y : Subgroup.center G), x * y = y * x := by
  exact ⟨inferInstance, mul_comm⟩