import Mathlib

-- Sub-lemma 1: a^m = a^n is equivalent to a^(m-n) = 1
lemma step1_pow_eq_iff_pow_sub_eq_one {G : Type*} [Group G] (a : G) (m n : ℤ) : a ^ m = a ^ n ↔ a ^ (m - n) = 1 := by
  -- This is equivalent to a^m * (a^n)⁻¹ = 1, which is a^(m-n) = 1.
  rw [← mul_inv_eq_one, ← zpow_sub]

-- Sub-lemma 2: If a has infinite order, a^k = 1 implies k = 0