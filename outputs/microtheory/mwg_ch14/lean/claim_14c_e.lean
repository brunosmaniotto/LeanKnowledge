import Mathlib

theorem distortion_increases_with_lam_H
    (lam_H1 lam_H2 : ℝ)
    (h1_pos : 0 < lam_H1) (h1_lt : lam_H1 < 1)
    (h2_pos : 0 < lam_H2) (h2_lt : lam_H2 < 1)
    (h_lt : lam_H1 < lam_H2) :
    lam_H1 / (1 - lam_H1) < lam_H2 / (1 - lam_H2) := by
  have h1 : (1 : ℝ) - lam_H1 ≠ 0 := by linarith
  have h2 : (1 : ℝ) - lam_H2 ≠ 0 := by linarith
  rw [div_lt_div_iff₀ (by linarith : 0 < 1 - lam_H1) (by linarith : 0 < 1 - lam_H2)]
  nlinarith