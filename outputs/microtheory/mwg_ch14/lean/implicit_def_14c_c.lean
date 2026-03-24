import Mathlib

structure CompleteInfoContract where
  θ_L : ℝ
  θ_H : ℝ
  prob_H : ℝ
  h_order : θ_H > θ_L
  h_prob_pos : 0 < prob_H
  h_prob_lt : prob_H < 1
  w_H : ℝ
  e_H : ℝ
  w_L : ℝ
  e_L : ℝ