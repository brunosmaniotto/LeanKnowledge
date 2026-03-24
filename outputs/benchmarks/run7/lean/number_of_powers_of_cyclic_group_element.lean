import Mathlib

open Subgroup

theorem cyclic_group_power_card (G : Type*) [Group G] [Fintype G] [IsCyclic G]
    (g : G) (n : ℕ) (hG : Fintype.card G = n) (hg : orderOf g = Fintype.card G)
    (d : ℕ) (hd : d ∣ n) : Fintype.card (zpowers (g ^ (n / d))) = d := by
  have hg_order : orderOf g = n := by rw [hG] at hg; exact hg
  have h_order : orderOf (g ^ (n / d)) = orderOf g / Nat.gcd (orderOf g) (n / d) := by
    rw [orderOf_pow]
  rw [hg_order] at h_order
  have h_div : n / d ∣ n := by
    refine ⟨d, ?_⟩
    rw [mul_comm, Nat.mul_div_cancel' hd]
  have h_gcd : Nat.gcd n (n / d) = n / d :=
    Nat.gcd_eq_right h_div
  rw [h_gcd] at h_order
  have hn_pos : 0 < n := by
    rw [← hG]
    exact Fintype.card_pos
  have hd_pos : 0 < d := Nat.pos_of_dvd_of_pos hd hn_pos
  have h_div_pos : 0 < n / d := Nat.div_pos (Nat.le_of_dvd hn_pos hd) hd_pos
  have H : n = (n / d) * d := by
    rw [mul_comm, Nat.mul_div_cancel' hd]
  rw [Nat.div_eq_of_eq_mul_right h_div_pos H] at h_order
  rw [Fintype.card_zpowers, h_order]