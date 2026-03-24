import Mathlib

open Function

theorem self_inverse_iff_orderOf_eq_two {G : Type} [Group G] (x : G) :
    x * x = 1 ∧ x ≠ 1 ↔ orderOf x = 2 := by
  constructor
  · rintro ⟨hx2, hx1⟩
    have h_dvd : orderOf x ∣ 2 := by
      rw [orderOf_dvd_iff_pow_eq_one, pow_two]
      exact hx2
    have prime2 : Nat.Prime 2 := by norm_num
    cases' prime2.eq_one_or_self_of_dvd (orderOf x) h_dvd with h h
    · exfalso
      apply hx1
      rw [← orderOf_eq_one_iff]
      exact h
    · exact h
  · intro h
    have h1 : x ^ 2 = 1 := by
      rw [← pow_orderOf_eq_one, h, pow_two]
    rw [pow_two] at h1
    refine ⟨h1, ?_⟩
    intro hx
    rw [hx, orderOf_one] at h
    norm_num at h