import Mathlib

open Metric Filter
open Topology

theorem claim_M_J_b :
    (deriv (deriv (fun x : ℝ => x ^ 3)) 0 = 0) ∧
    (¬ IsLocalMax (fun x : ℝ => x ^ 3) 0) ∧
    (¬ IsLocalMin (fun x : ℝ => x ^ 3) 0) := by
  refine ⟨?_, ?_, ?_⟩
  · -- Second derivative of x³ at 0 is 0
    have h1 : deriv (fun x : ℝ => x ^ 3) = fun x => 3 * x ^ 2 := by
      ext x; simp [pow_succ, pow_zero, one_mul]; ring
    rw [h1]; simp
  · -- 0 is not a local max of x³
    intro hmax
    have hev : ∀ᶠ x in 𝓝 (0 : ℝ), x ^ 3 ≤ (0 : ℝ) ^ 3 := hmax
    simp only [pow_succ, pow_zero, one_mul, mul_zero] at hev
    rw [Filter.Eventually, Metric.mem_nhds_iff] at hev
    obtain ⟨ε, hε_pos, hball⟩ := hev
    have hε2 : ε / 2 > 0 := by linarith
    have hmem : ε / 2 ∈ ball (0 : ℝ) ε := by
      simp only [mem_ball, dist_zero_right, Real.norm_eq_abs, abs_of_pos hε2]; linarith
    have h1 := hball hmem
    simp only [Set.mem_setOf_eq] at h1
    nlinarith [mul_pos hε2 hε2, mul_pos (mul_pos hε2 hε2) hε2]
  · -- 0 is not a local min of x³
    intro hmin
    have hev : ∀ᶠ x in 𝓝 (0 : ℝ), (0 : ℝ) ^ 3 ≤ x ^ 3 := hmin
    simp only [pow_succ, pow_zero, one_mul, mul_zero] at hev
    rw [Filter.Eventually, Metric.mem_nhds_iff] at hev
    obtain ⟨ε, hε_pos, hball⟩ := hev
    have hε2 : ε / 2 > 0 := by linarith
    have hmem : -(ε / 2) ∈ ball (0 : ℝ) ε := by
      simp only [mem_ball, dist_zero_right, Real.norm_eq_abs, abs_neg, abs_of_pos hε2]; linarith
    have h1 := hball hmem
    simp only [Set.mem_setOf_eq] at h1
    nlinarith [mul_pos hε2 hε2, mul_pos (mul_pos hε2 hε2) hε2]