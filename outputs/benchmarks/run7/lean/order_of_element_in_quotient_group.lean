import Mathlib

theorem orderOf_quotient_dvd_orderOf {G : Type*} [Group G] (H : Subgroup G) [H.Normal] (a : G) :
    orderOf (QuotientGroup.mk' H a) ∣ orderOf a := by
  have hpow : (QuotientGroup.mk' H a) ^ orderOf a = 1 := by
    calc
      (QuotientGroup.mk' H a) ^ orderOf a = QuotientGroup.mk' H (a ^ orderOf a) := by rw [map_pow]
      _ = QuotientGroup.mk' H 1 := by rw [pow_orderOf_eq_one]
      _ = 1 := by rw [map_one]
  exact orderOf_dvd_iff_pow_eq_one.mpr hpow