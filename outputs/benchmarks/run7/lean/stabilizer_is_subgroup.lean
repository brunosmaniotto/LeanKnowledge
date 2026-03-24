import Mathlib

theorem stabilizer_subgroup_properties (G : Type*) [Group G] (X : Type*) [MulAction G X] (x : X) :
    (1 : G) • x = x ∧
    (∀ g h : G, g • x = x → h • x = x → (g * h) • x = x) ∧
    (∀ g : G, g • x = x → g⁻¹ • x = x) := by
  constructor
  · simp
  constructor
  · intro g h hg hh
    rw [mul_smul, hh, hg]
  · intro g hg
    rw [inv_smul_eq_iff, hg]