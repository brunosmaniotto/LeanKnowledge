import Mathlib

open Nat Real

noncomputable def sigma_pd_sq (N : ℕ) : ℝ :=
  ((N : ℝ) - 1) ^ 2 / (N * (N + 1) ^ 2 * (N + 2))

noncomputable def sigma_gd_sq (N : ℕ) : ℝ :=
  (1 / ((N : ℝ) - 1) ^ 2) * (sigma_pd_sq N)

theorem Claim_Vickrey3_p31_a (N : ℕ) (hN : N ≥ 2) :
    sigma_gd_sq N = 1 / (N * (N + 1) ^ 2 * (N + 2)) := by
  -- Unfold definitions
  simp only [sigma_gd_sq, sigma_pd_sq]

  -- Prove non-zero denominators needed for `field_simp`
  have h_N_ge_2_real : (N : ℝ) ≥ 2 := by exact_mod_cast hN

  have h_N_minus_1_nonzero : (N : ℝ) - 1 ≠ 0 := by linarith
  have h_N_minus_1_sq_nonzero : ((N : ℝ) - 1) ^ 2 ≠ 0 := by
    exact pow_ne_zero 2 h_N_minus_1_nonzero

  have h_N_nonzero : (N : ℝ) ≠ 0 := by linarith

  have h_N_plus_1_nonzero : (N : ℝ) + 1 ≠ 0 := by linarith
  have h_N_plus_1_sq_nonzero : ((N : ℝ) + 1) ^ 2 ≠ 0 := by
    exact pow_ne_zero 2 h_N_plus_1_nonzero

  have h_N_plus_2_nonzero : (N : ℝ) + 2 ≠ 0 := by linarith

  -- Simplify the rational expression.
  -- This cancels the ((N:ℝ) - 1)^2 term and simplifies the expression to the goal.
  field_simp [h_N_minus_1_sq_nonzero, h_N_nonzero, h_N_plus_1_sq_nonzero, h_N_plus_2_nonzero]