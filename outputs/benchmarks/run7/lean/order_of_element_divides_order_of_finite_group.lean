import Mathlib

theorem orderOf_dvd_group_card (G : Type) [Group G] [Fintype G] (x : G) : orderOf x ∣ Fintype.card G :=
  orderOf_dvd_card