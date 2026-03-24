import Mathlib

open Filter Topology BigOperators Finset
open Finset

theorem Claim_5_2_normalization
    (L : ℕ) [NeZero L]
    (z : (Fin L → ℝ) → (Fin L → ℝ))
    (h_homog : ∀ (lambda_val : ℝ), 0 < lambda_val → ∀ (p : Fin L → ℝ), (∀ i, 0 < p i) → z (lambda_val • p) = z p)
    (p : Fin L → ℝ) (h_p_pos : ∀ i, 0 < p i) :
    ∃ (lambda_factor : ℝ), 0 < lambda_factor ∧ (Finset.sum Finset.univ fun i => (lambda_factor • p) i) = 1 ∧ z (lambda_factor • p) = z p :=
  by
  -- Define sum_p as the sum of all components of p
  let sum_p := Finset.sum Finset.univ p

  -- Prove that sum_p is positive
  have h_sum_p_pos : 0 < sum_p := by
    apply Finset.sum_pos
    · intro i _
      exact h_p_pos i
    · apply Finset.univ_nonempty

  -- Define lambda_factor as the reciprocal of sum_p
  let lambda_factor := 1 / sum_p

  -- Prove that lambda_factor is positive
  have h_lambda_factor_pos : 0 < lambda_factor := by
    exact one_div_pos.mpr h_sum_p_pos

  -- Use the constructed lambda_factor
  use lambda_factor

  -- Prove the conjunction:
  -- 1. 0 < lambda_factor
  -- 2. (sum of normalized prices) = 1
  -- 3. z(normalized_p) = z(p)
  constructor
  · -- Proof for 0 < lambda_factor
    exact h_lambda_factor_pos
  constructor
  · -- Proof for (sum of normalized prices) = 1
    calc
      (Finset.sum Finset.univ fun i => (lambda_factor • p) i)
      _ = (Finset.sum Finset.univ fun i => lambda_factor * p i) := by simp [Pi.smul_apply, smul_eq_mul]
      _ = lambda_factor * (Finset.sum Finset.univ p) := by rw [Finset.mul_sum]
      _ = (1 / sum_p) * sum_p := by rfl
      _ = 1 := by field_simp [h_sum_p_pos.ne']
  · -- Proof for z(lambda_factor • p) = z(p)
    apply h_homog lambda_factor h_lambda_factor_pos p h_p_pos