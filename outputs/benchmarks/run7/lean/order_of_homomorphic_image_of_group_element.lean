import Mathlib

variable {G H : Type*} [Group G] [Group H]

theorem orderOf_hom_dvd (φ : G →* H) (g : G) : orderOf (φ g) ∣ orderOf g := by
  apply orderOf_dvd_of_pow_eq_one
  rw [← φ.map_pow, pow_orderOf_eq_one, φ.map_one]