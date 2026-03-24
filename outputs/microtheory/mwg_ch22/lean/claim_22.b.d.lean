import Mathlib

open Real

theorem second_best_price_distortion
    (p1_bar : ℝ)
    (hp1 : p1_bar > 1)
    (dx1_dp2 : ℝ)
    (h_nonsep : dx1_dp2 ≠ 0)
    (surplus_gain : ℝ → ℝ)
    (h_surplus : surplus_gain 1 = (p1_bar - 1) * |dx1_dp2|)
    : surplus_gain 1 > 0 := by
  rw [h_surplus]
  apply mul_pos
  · linarith
  · exact abs_pos.mpr h_nonsep