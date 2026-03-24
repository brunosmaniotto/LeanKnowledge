import Mathlib

theorem Action_of_Group_on_Coset_Space_is_Group_Action
  (G : Type*) [Group G] (H : Subgroup G) :
  (∀ (g₁ g₂ : G) (x : G ⧸ H), (g₁ * g₂) • x = g₁ • (g₂ • x)) ∧
  (∀ (x : G ⧸ H), (1 : G) • x = x) := by
  constructor
  · exact mul_smul
  · exact one_smul G