import Mathlib

theorem exists_square_of_odd_order {G : Type*} [Group G] (x : G) (h : Odd (orderOf x)) :
    ∃ y : G, y ^ 2 = x := by
  obtain ⟨k, hk⟩ := h
  have h1 : x ^ (orderOf x) = 1 := pow_orderOf_eq_one x
  rw [hk] at h1
  use x ^ (k + 1)
  calc
    (x ^ (k + 1)) ^ 2 = x ^ ((k + 1) * 2) := by rw [← pow_mul]
    _ = x ^ ((2 * k + 1) + 1) := by
      have : (k + 1) * 2 = (2 * k + 1) + 1 := by omega
      rw [this]
    _ = x ^ (2 * k + 1) * x := by rw [pow_succ]
    _ = 1 * x := by rw [h1]
    _ = x := by group