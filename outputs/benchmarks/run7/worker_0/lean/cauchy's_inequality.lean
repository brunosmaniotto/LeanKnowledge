import Mathlib

open Finset
open BigOperators

theorem cauchy_inequality {ι : Type*} [Fintype ι] (r s : ι → ℝ) :
    (∑ i, r i ^ 2) * (∑ i, s i ^ 2) ≥ (∑ i, r i * s i) ^ 2 := by
  set A := ∑ i, s i ^ 2 with hA_def
  set B := ∑ i, r i * s i with hB_def
  set C := ∑ i, r i ^ 2 with hC_def
  have nonneg_sq : ∀ (x : ℝ), 0 ≤ ∑ i, (r i + x * s i) ^ 2 := by
    intro x
    exact sum_nonneg (fun i _ => by positivity)
  have expr_eq : ∀ (x : ℝ), ∑ i, (r i + x * s i) ^ 2 = A * x ^ 2 + 2 * B * x + C := by
    intro x
    calc
      ∑ i, (r i + x * s i) ^ 2 = ∑ i, (r i ^ 2 + 2 * x * (r i * s i) + (x * s i) ^ 2) := by
        congr; ext i; ring
      _ = (∑ i, r i ^ 2) + (∑ i, 2 * x * (r i * s i)) + (∑ i, (x * s i) ^ 2) := by
        simp [sum_add_distrib]
      _ = C + (∑ i, 2 * x * (r i * s i)) + (∑ i, x ^ 2 * s i ^ 2) := by
        simp [hC_def, mul_pow]
      _ = C + (2 * x * B) + (x ^ 2 * A) := by
        simp [hA_def, hB_def, mul_sum, sum_mul, mul_assoc, mul_left_comm, mul_comm]
      _ = A * x ^ 2 + 2 * B * x + C := by ring
  by_cases hA : A = 0
  · have h_sq_zero : ∀ i, s i ^ 2 = 0 := by
      rw [hA_def] at hA
      intro i
      exact (sum_eq_zero_iff_of_nonneg (fun i _ => sq_nonneg (s i))).mp hA i (mem_univ i)
    have h_s_zero : ∀ i, s i = 0 := fun i => pow_eq_zero (h_sq_zero i)
    have hB_zero : B = 0 := by
      simp [hB_def, h_s_zero]
    simp [hA, hB_zero, hC_def]
  · have A_nonneg : 0 ≤ A := sum_nonneg fun i _ => by positivity
    have A_pos : 0 < A := lt_of_le_of_ne A_nonneg (Ne.symm hA)
    have h_min : 0 ≤ ∑ i, (r i + (-B / A) * s i) ^ 2 := nonneg_sq (-B / A)
    rw [expr_eq] at h_min
    field_simp [ne_of_gt A_pos] at h_min
    nlinarith