import Mathlib

theorem Claim_4_2_1_c (a c : ℝ) (h_ac : a > c) (J : ℕ) (hJ : J ≥ 1) :
  (a - c) / (J + 1 : ℝ) ≤ (a - c) / (1 + 1 : ℝ) :=
by
  -- We want to show (a - c) / (J + 1 : ℝ) ≤ (a - c) / (1 + 1 : ℝ)
  -- Since a - c > 0, this inequality is equivalent to 1 / (J + 1 : ℝ) ≤ 1 / (1 + 1 : ℝ).
  -- Because both denominators are positive, this in turn is equivalent to (1 + 1 : ℝ) ≤ (J + 1 : ℝ).

  have h_pos_num : 0 < a - c := sub_pos.mpr h_ac
  have h_denom_J_pos : (J + 1 : ℝ) > 0 := by positivity
  have h_denom_1_pos : (1 + 1 : ℝ) > 0 := by positivity

  apply (div_le_div_iff_of_pos_left h_pos_num h_denom_J_pos h_denom_1_pos).mpr

  -- The goal is now to prove: (1 + 1 : ℝ) ≤ (J + 1 : ℝ)
  norm_cast -- Push the `ℝ` cast inside the addition.
  -- Goal: 1 + 1 ≤ J + 1
  simp -- Simplify 1 + 1 to 2.
  -- Goal: 2 ≤ J + 1
  -- Since `hJ : J ≥ 1`, it follows that `J + 1 ≥ 1 + 1`, which is `J + 1 ≥ 2`.
  omega