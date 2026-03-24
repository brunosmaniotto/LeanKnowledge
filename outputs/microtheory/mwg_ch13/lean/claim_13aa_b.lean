import Mathlib

structure SignalingDominance where
  θ_L : ℝ
  θ_H : ℝ
  c_e_hat_L : ℝ
  c_e_L : ℝ
  h_types : θ_L < θ_H
  h_θ_L_pos : 0 < θ_L
  h_indiff : θ_H - c_e_hat_L = θ_L
  h_cost_mono : c_e_hat_L < c_e_L
  h_cost_pos : 0 < c_e_hat_L

theorem dominance_eliminates_high_education (M : SignalingDominance) :
    M.θ_H - M.c_e_L < M.θ_L := by
  linarith [M.h_indiff, M.h_cost_mono]