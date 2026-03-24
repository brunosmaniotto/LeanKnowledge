import Mathlib

theorem Example_2_4 :
    let u_10 : ℝ := 1
    let u_neg2 : ℝ := 0
    let u_4 : ℝ := 0.6
    let u_g1 := 0.2 * u_4 + 0.8 * u_10
    let u_g2 := 0.07 * u_neg2 + 0.03 * u_4 + 0.9 * u_10
    u_g1 = 0.92 ∧ u_g2 = 0.918 ∧ u_g1 > u_g2 := by
  norm_num