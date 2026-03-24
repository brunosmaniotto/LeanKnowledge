import Mathlib

-- Proved sub-lemma 1
lemma zpow_eq_zpow_iff_zpow_sub_eq_one {G : Type*} [Group G] (g : G) (r s : ℤ) : g ^ r = g ^ s ↔ g ^ (r - s) = 1 := by
  rw [← mul_inv_eq_one, zpow_sub]

-- Proved sub-lemma 2