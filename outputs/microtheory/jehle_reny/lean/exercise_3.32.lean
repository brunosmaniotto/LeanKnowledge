import Mathlib
open Topology

theorem Exercise_3_32
    (C : ℝ → ℝ) (q : ℝ) (hq : 0 < q) (hC : DifferentiableAt ℝ C q) :
    (deriv (fun x => C x / x) q < 0 → deriv C q < C q / q) ∧
    (deriv (fun x => C x / x) q = 0 → deriv C q = C q / q) ∧
    (0 < deriv (fun x => C x / x) q → C q / q < deriv C q) := by
  have hq' : q ≠ 0 := hq.ne'
  have hq2pos : (0 : ℝ) < q ^ 2 := pow_pos hq 2
  have hdiv : HasDerivAt (fun x => C x / x)
      ((deriv C q * q - C q) / q ^ 2) q := by
    have h := hC.hasDerivAt.div (hasDerivAt_id q) hq'
    simp only [mul_one] at h; exact h
  rw [hdiv.deriv]
  refine ⟨fun h => ?_, fun h => ?_, fun h => ?_⟩
  · have h1 : deriv C q * q - C q < 0 := by
      by_contra h2; push_neg at h2
      linarith [div_nonneg h2 hq2pos.le]
    have h2 : (deriv C q * q - C q) / q < 0 := div_neg_of_neg_of_pos h1 hq
    rw [sub_div, mul_div_cancel_right₀ _ hq'] at h2; linarith
  · have h1 : deriv C q * q = C q := by
      by_contra h2
      exact absurd h (div_ne_zero (sub_ne_zero.mpr h2) hq2pos.ne')
    field_simp [hq']; linarith
  · have h1 : 0 < deriv C q * q - C q := by
      by_contra h2; push_neg at h2
      have h3 := div_nonneg (show 0 ≤ -(deriv C q * q - C q) by linarith) hq2pos.le
      rw [neg_div] at h3; linarith
    have h2 : 0 < (deriv C q * q - C q) / q := div_pos h1 hq
    rw [sub_div, mul_div_cancel_right₀ _ hq'] at h2; linarith