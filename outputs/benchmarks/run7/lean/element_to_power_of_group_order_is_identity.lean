import Mathlib

theorem Element_to_Power_of_Group_Order_is_Identity (G : Type*) [Group G] [Fintype G] (g : G) :
    g ^ (Fintype.card G) = 1 := by
  have h_dvd : orderOf g ∣ Fintype.card G := orderOf_dvd_card
  rcases h_dvd with ⟨m, hm⟩
  rw [hm]
  rw [pow_mul]
  rw [pow_orderOf_eq_one]
  rw [one_pow]