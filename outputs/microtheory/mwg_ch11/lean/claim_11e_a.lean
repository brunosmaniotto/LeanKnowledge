import Mathlib

open Set Real
open Topology

-- The objective function for the consumer
-- G represents the cumulative distribution function (or similar) of firm's willingness to accept.
-- c represents the consumer's cost if the externality is allowed.
noncomputable def consumer_objective (G : ℝ → ℝ) (c : ℝ) (T : ℝ) : ℝ := (1 - G T) * (T - c)

-- Theorem (Claim_11E_a): Bargaining under bilateral asymmetric information will not lead to an efficient externality level.
-- This formal Lean proof specifically demonstrates that the consumer's optimal demand T* must be strictly greater than their cost c.
-- This fact is a prerequisite for the inefficiency described in the theorem statement.
theorem Claim_11E_a (c : ℝ) (c_pos : c > 0)
  (G : ℝ → ℝ)
  (G_le_one : ∀ t, G t ≤ 1) -- G(T) is at most 1 (as a probability)
  (exists_T_prime_gt_c_G_lt_one : ∃ T', T' > c ∧ G T' < 1) -- Asserts there's a positive probability of acceptance for some offer T' > c
  (T_star : ℝ)
  (h_max_T_star : ∀ T, consumer_objective G c T ≤ consumer_objective G c T_star) : -- T_star maximizes the consumer's objective
  T_star > c :=
by
  -- The proof proceeds by showing that the objective function at c is zero,
  -- but there exists some T' > c where the objective function is strictly positive.
  -- Since T_star is a maximizer, the objective function at T_star must also be strictly positive,
  -- which implies T_star cannot be less than or equal to c.

  -- 1. Show that the consumer's objective is zero when T = c.
  have h_obj_c_zero : consumer_objective G c c = 0 :=
  by
    simp only [consumer_objective]
    rw [sub_self c, mul_zero]

  -- 2. Use the assumption `exists_T_prime_gt_c_G_lt_one` to find a T' where the objective is positive.
  obtain ⟨T_prime, hT_prime_gt_c, hG_T_prime_lt_one⟩ := exists_T_prime_gt_c_G_lt_one

  -- Establish that `1 - G T_prime` is positive.
  have h_1_minus_G_T_prime_pos : 1 - G T_prime > 0 := by linarith [hG_T_prime_lt_one]

  -- Establish that `T_prime - c` is positive.
  have h_T_prime_c_pos : T_prime - c > 0 := by linarith [hT_prime_gt_c]

  -- Since both factors are positive, their product (the objective function at T_prime) is positive.
  have h_obj_T_prime_pos : consumer_objective G c T_prime > 0 :=
  by
    simp only [consumer_objective]
    exact mul_pos h_1_minus_G_T_prime_pos h_T_prime_c_pos

  -- 3. Since T_star is a maximizer, the value at T_star must be at least the value at T_prime.
  have h_obj_T_star_ge_obj_T_prime : consumer_objective G c T_star ≥ consumer_objective G c T_prime :=
    h_max_T_star T_prime

  -- Combining `h_obj_T_prime_pos` and `h_obj_T_star_ge_obj_T_prime`, we get that the objective at T_star is strictly positive.
  have h_obj_T_star_pos : consumer_objective G c T_star > 0 :=
  calc
    consumer_objective G c T_star ≥ consumer_objective G c T_prime := h_obj_T_star_ge_obj_T_prime
    _ > 0 := h_obj_T_prime_pos

  -- 4. Finally, prove `T_star > c` by contradiction.
  by_contra h_not_T_star_gt_c
  push_neg at h_not_T_star_gt_c -- This means `T_star ≤ c`.

  -- If `T_star ≤ c`, then `T_star - c ≤ 0`.
  have h_T_star_c_le_zero : T_star - c ≤ 0 := sub_nonpos.mpr h_not_T_star_gt_c

  -- Also, `1 - G T_star ≥ 0` because `G T_star ≤ 1` (from `G_le_one`).
  have h_1_minus_G_T_star_nonneg : 1 - G T_star ≥ 0 := sub_nonneg.mpr (G_le_one T_star)

  -- The objective function at T_star is the product of a non-negative term and a non-positive term.
  -- Thus, `consumer_objective G c T_star ≤ 0`.
  have h_obj_T_star_nonpos : consumer_objective G c T_star ≤ 0 :=
  by
    simp only [consumer_objective]
    exact mul_nonpos_of_nonneg_of_nonpos h_1_minus_G_T_star_nonneg h_T_star_c_le_zero

  -- This creates a contradiction with `h_obj_T_star_pos`.
  linarith [h_obj_T_star_pos, h_obj_T_star_nonpos]