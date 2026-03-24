import Mathlib

variable {G H : Type*} [Group G] [Group H] (φ : G →* H) (x y : G)

theorem group_homomorphism_product_inverse :
    φ (x * y⁻¹) = φ x * (φ y)⁻¹ ∧ φ (y⁻¹ * x) = (φ y)⁻¹ * φ x := by
  constructor
  · rw [φ.map_mul, φ.map_inv]
  · rw [φ.map_mul, φ.map_inv]