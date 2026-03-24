import Mathlib

variable {G H : Type*} [Group G] [Group H]

theorem orderOf_prod (g : G) (h : H) : orderOf (g, h) = Nat.lcm (orderOf g) (orderOf h) := by
  apply Nat.dvd_antisymm
  · apply orderOf_dvd_of_pow_eq_one
    ext <;> simp [← orderOf_dvd_iff_pow_eq_one, Nat.dvd_lcm_left, Nat.dvd_lcm_right]
  · have h_prod := pow_orderOf_eq_one (g, h)
    have hg : g ^ orderOf (g, h) = 1 := congr_arg Prod.fst h_prod
    have hh : h ^ orderOf (g, h) = 1 := congr_arg Prod.snd h_prod
    have hg_dvd : orderOf g ∣ orderOf (g, h) := by
      rw [orderOf_dvd_iff_pow_eq_one]
      exact hg
    have hh_dvd : orderOf h ∣ orderOf (g, h) := by
      rw [orderOf_dvd_iff_pow_eq_one]
      exact hh
    exact Nat.lcm_dvd hg_dvd hh_dvd