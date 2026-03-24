import Mathlib

open Topology Filter Classical
open BigOperators

theorem Claim_4_4_b (a c b : ℝ) (J : ℕ) (hJ : J ≥ 1)
    (hab : a > c) (hb : b > 0) :
    let q_bar := (↑J : ℝ) * (a - c) / ((↑J + 1) * b)
    let q_star := (a - c) / b
    q_bar < q_star := by
  simp only
  have hJ_pos : (↑J : ℝ) ≥ 1 := by exact_mod_cast hJ
  have hJ1_pos : (↑J : ℝ) + 1 > 0 := by linarith
  have hJb_pos : (↑J + 1) * b > 0 := mul_pos hJ1_pos hb
  have hac : a - c > 0 := by linarith
  have hb_ne : b ≠ 0 := ne_of_gt hb
  have hJ1_ne : (↑J : ℝ) + 1 ≠ 0 := ne_of_gt hJ1_pos
  have hJb_ne : (↑J + 1) * b ≠ 0 := ne_of_gt hJb_pos
  rw [div_lt_div_iff₀ hJb_pos hb]
  nlinarith