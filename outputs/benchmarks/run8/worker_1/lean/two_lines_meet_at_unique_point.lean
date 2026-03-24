import Mathlib

theorem two_lines_meet_unique_point (b : ℝ) (hb : b > 0) (C D : ℝ × ℝ) (hy1 : C.2 > 0) (hy2 : D.2 > 0)
    (hAC : C.1 ^ 2 + C.2 ^ 2 = D.1 ^ 2 + D.2 ^ 2)
    (hCB : (b - C.1) ^ 2 + C.2 ^ 2 = (b - D.1) ^ 2 + D.2 ^ 2) : C = D := by
  have H : (b - C.1) ^ 2 - C.1 ^ 2 = (b - D.1) ^ 2 - D.1 ^ 2 := by
    linarith
  ring_nf at H
  have Hx : C.1 = D.1 := by
    nlinarith
  rw [Hx] at hAC
  have H2 : C.2 ^ 2 = D.2 ^ 2 := by
    nlinarith
  have Hy : C.2 = D.2 := by
    nlinarith
  ext <;> simp [Hx, Hy]