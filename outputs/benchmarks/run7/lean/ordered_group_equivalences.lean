import Mathlib

lemma ordered_group_equiv_1_2 {G : Type*} [Group G] [LT G] (hcompat : ∀ a b c : G, a < b → a * c < b * c) (x y z : G) : x < y ↔ x * z < y * z := by
  constructor
  · exact hcompat x y z
  · intro h
    have h1 : x * z * z⁻¹ < y * z * z⁻¹ := hcompat (x * z) (y * z) z⁻¹ h
    simp at h1
    exact h1