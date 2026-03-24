import Mathlib

theorem Claim_A2_1_1_f :
    (∀ x y : ℝ, x ≠ y → ∀ t : ℝ, 0 < t → t < 1 →
      -(t * x + (1 - t) * y) ^ 4 > t * (-(x ^ 4)) + (1 - t) * (-(y ^ 4))) ∧
    (deriv (deriv (fun x : ℝ => -(x ^ 4))) 0 = 0) := by
  constructor
  · intro x y hxy t ht0 ht1
    have hs : 0 < 1 - t := sub_pos.mpr ht1
    have hts : 0 < t * (1 - t) := mul_pos ht0 hs
    have hd : x - y ≠ 0 := sub_ne_zero.mpr hxy
    have hd2 : 0 < (x - y) ^ 2 := by positivity
    have hQ : 0 < 6 * y ^ 2 + 4 * (1 + t) * y * (x - y) +
        (1 + t + t ^ 2) * (x - y) ^ 2 := by
      have h1 : 0 ≤ 2 * (3 * y + (1 + t) * (x - y)) ^ 2 := by positivity
      have h2 : 0 < (t ^ 2 - t + 1) * (x - y) ^ 2 := by
        apply mul_pos _ hd2; nlinarith [sq_nonneg (t - 1 / 2)]
      have h3 : 3 * (6 * y ^ 2 + 4 * (1 + t) * y * (x - y) +
          (1 + t + t ^ 2) * (x - y) ^ 2) =
        2 * (3 * y + (1 + t) * (x - y)) ^ 2 +
        (t ^ 2 - t + 1) * (x - y) ^ 2 := by ring
      linarith
    have hfact : t * x ^ 4 + (1 - t) * y ^ 4 - (t * x + (1 - t) * y) ^ 4 =
        t * (1 - t) * (x - y) ^ 2 *
        (6 * y ^ 2 + 4 * (1 + t) * y * (x - y) +
        (1 + t + t ^ 2) * (x - y) ^ 2) := by ring
    nlinarith [mul_pos (mul_pos hts hd2) hQ]
  · simp