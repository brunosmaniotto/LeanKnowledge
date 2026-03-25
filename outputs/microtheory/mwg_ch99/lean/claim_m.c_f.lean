import Mathlib
open Topology

theorem claim_M_C_f :
    (deriv (deriv (fun x : ℝ => -(x ^ 4))) 0 = 0) ∧
    (∀ x y : ℝ, x ≠ y → ∀ t : ℝ, 0 < t → t < 1 →
      -(t * x + (1 - t) * y) ^ 4 > t * (-(x ^ 4)) + (1 - t) * (-(y ^ 4))) := by
  refine ⟨?_, ?_⟩
  · have h1 : (fun x : ℝ => -(x ^ 4)) = fun x => -1 * x ^ 4 := by ext x; ring
    rw [h1]; simp [deriv_pow]
  · intro x y hxy t ht0 ht1
    have h1t : 0 < 1 - t := by linarith
    have hts : 0 < t * (1 - t) := mul_pos ht0 h1t
    have hd_ne : x - y ≠ 0 := sub_ne_zero.mpr hxy
    have hd2 : 0 < (x - y) ^ 2 := by positivity
    suffices h : (t * x + (1 - t) * y) ^ 4 < t * x ^ 4 + (1 - t) * y ^ 4 by nlinarith
    have hid : t * x ^ 4 + (1 - t) * y ^ 4 - (t * x + (1 - t) * y) ^ 4 =
        t * (1 - t) * (x - y) ^ 2 *
        (6 * y ^ 2 + 4 * (1 + t) * (x - y) * y +
          (1 + t + t ^ 2) * (x - y) ^ 2) := by ring
    have hQ : 0 < 6 * y ^ 2 + 4 * (1 + t) * (x - y) * y +
        (1 + t + t ^ 2) * (x - y) ^ 2 := by
      have h_sq : 0 ≤ (3 * y + (1 + t) * (x - y)) ^ 2 := sq_nonneg _
      have h_coeff : 0 < 1 - t + t ^ 2 := by nlinarith [sq_nonneg (t - 1 / 2)]
      have h_pos : 0 < (1 - t + t ^ 2) * (x - y) ^ 2 := mul_pos h_coeff hd2
      nlinarith
    linarith [mul_pos (mul_pos hts hd2) hQ]