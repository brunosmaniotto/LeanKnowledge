import Mathlib

theorem orderOf_eq_of_isomorphism {G H : Type*} [Group G] [Group H] (e : G ≃* H) (a : G) :
    orderOf (e a) = orderOf a := by
  have h1 : orderOf (e a) ∣ orderOf a :=
    orderOf_map_dvd (e : G →* H) a
  have h2 : orderOf a ∣ orderOf (e a) := by
    have h2' : orderOf ((e.symm : H →* G) (e a)) ∣ orderOf (e a) :=
      orderOf_map_dvd (e.symm : H →* G) (e a)
    simpa [e.symm_apply_apply] using h2'
  exact Nat.dvd_antisymm h1 h2