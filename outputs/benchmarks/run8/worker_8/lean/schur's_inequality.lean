import Mathlib
open Real

lemma schur_ordered (x y z t : ℝ) (hx : 0 ≤ x) (hy : 0 ≤ y) (hz : 0 ≤ z) (ht : 0 < t) (hxy : x ≥ y) (hyz : y ≥ z) :
    x ^ t * (x - y) * (x - z) + y ^ t * (y - z) * (y - x) + z ^ t * (z - x) * (z - y) ≥ 0 := by
  have key : x ^ t * (x - y) * (x - z) + y ^ t * (y - z) * (y - x) + z ^ t * (z - x) * (z - y) =
      (x - y) * (x ^ t * (x - z) - y ^ t * (y - z)) + z ^ t * (x - z) * (y - z) := by ring
  rw [key]
  have h1 : 0 ≤ x - y := sub_nonneg.mpr hxy
  have h2 : 0 ≤ y - z := sub_nonneg.mpr hyz
  have h3 : 0 ≤ x - z := by linarith
  have h4 : 0 ≤ x ^ t := Real.rpow_nonneg hx t
  have h5 : 0 ≤ y ^ t := Real.rpow_nonneg hy t
  have h6 : 0 ≤ z ^ t := Real.rpow_nonneg hz t
  have h_pow : y ^ t ≤ x ^ t := Real.rpow_le_rpow hy (by linarith) (le_of_lt ht)
  have h7 : 0 ≤ x ^ t * (x - z) - y ^ t * (y - z) := by
    have h8 : y ^ t * (y - z) ≤ x ^ t * (y - z) := mul_le_mul_of_nonneg_right h_pow h2
    have h9 : x ^ t * (y - z) ≤ x ^ t * (x - z) := mul_le_mul_of_nonneg_left (by linarith) h4
    linarith
  have h8 : 0 ≤ z ^ t * (x - z) * (y - z) := by
    have : 0 ≤ z ^ t * (x - z) := mul_nonneg h6 h3
    exact mul_nonneg this h2
  nlinarith