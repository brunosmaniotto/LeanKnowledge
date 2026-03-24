import Mathlib

theorem order_of_subgroup_of_cyclic (G : Type*) [Group G] [Fintype G] (g : G)
    (hg : orderOf g = Fintype.card G) (i : ℕ) :
    Fintype.card (Subgroup.zpowers (g ^ i)) = Fintype.card G / Nat.gcd (Fintype.card G) i := by
  calc
    Fintype.card (Subgroup.zpowers (g ^ i)) = orderOf (g ^ i) := by rw [Fintype.card_zpowers]
    _ = orderOf g / Nat.gcd (orderOf g) i := by rw [orderOf_pow]
    _ = Fintype.card G / Nat.gcd (Fintype.card G) i := by rw [hg]