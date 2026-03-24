import Mathlib

theorem Claim_II_O (N : ℕ) (hN : N > 1) (P : Type) (v : P → ℝ) :
    (∀ p_max : P, (∀ p' : P, v p' ≤ v p_max) → (∀ p : P, (((N : ℝ) - 1) / (N : ℝ)) * (v p) ≤ (((N : ℝ) - 1) / (N : ℝ)) * (v p_max))) :=
  by
    intro p_max hv_max p
    -- Define the bidding coefficient `c`.
    let c : ℝ := ((N : ℝ) - 1) / (N : ℝ)

    -- Prove that the bidding coefficient `c` is non-negative.
    have h_c_ge_zero : c ≥ 0 := by
      -- Cast `N > 1` (natural number) to real: `(N : ℝ) > 1`.
      have hN_real_gt_one : (N : ℝ) > 1 := by exact_mod_cast hN
      -- From `(N : ℝ) > 1`, it follows that `(N : ℝ) > 0`.
      have hN_real_pos : (N : ℝ) > 0 := by linarith [hN_real_gt_one]
      -- From `(N : ℝ) > 1`, it follows that `(N : ℝ) - 1 > 0`, which implies `(N : ℝ) - 1 ≥ 0`.
      have hN_minus_1_ge_zero : (N : ℝ) - 1 ≥ 0 := by linarith [hN_real_gt_one]
      -- Since the numerator `((N : ℝ) - 1)` is non-negative and the denominator `(N : ℝ)` is positive,
      -- their division `c` must be non-negative.
      exact div_nonneg hN_minus_1_ge_zero (le_of_lt hN_real_pos)

    -- Apply the property that multiplying an inequality by a non-negative number preserves the inequality.
    -- We use `hv_max p` (which states `v p ≤ v p_max`) and `h_c_ge_zero` (which states `c ≥ 0`).
    calc
      c * (v p) ≤ c * (v p_max) := mul_le_mul_of_nonneg_left (hv_max p) h_c_ge_zero