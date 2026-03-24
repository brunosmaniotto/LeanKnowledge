import Mathlib

variable {G H : Type*} [Group G] [Group H]

theorem hom_pow_eq_pow_hom (φ : G →* H) (g : G) (n : ℤ) : φ (g ^ n) = (φ g) ^ n := by
  cases n <;> simp [map_pow, map_inv]