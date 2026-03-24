import Mathlib
open Topology

structure AdverseSelectionModel where
  pi' : ℝ → ℝ
  g_e : ℝ → ℝ → ℝ
  theta_L : ℝ
  theta_H : ℝ
  lam : ℝ
  e_star_L : ℝ
  e_L : ℝ
  hlam_pos : 0 < lam
  hlam_lt : lam < 1
  h_first_best : pi' e_star_L = g_e e_star_L theta_L
  h_foc : (pi' e_L - g_e e_L theta_L) + (lam / (1 - lam)) * (g_e e_L theta_H - g_e e_L theta_L) = 0
  h_single_crossing : ∀ e, g_e e theta_H < g_e e theta_L
  h_net_margin_decreasing : ∀ a b, a < b → pi' b - g_e b theta_L < pi' a - g_e a theta_L

theorem Condition_14C9 (P : AdverseSelectionModel) : P.e_L < P.e_star_L := by
  by_contra h
  push_neg at h
  have hd : 0 < 1 - P.lam := by linarith [P.hlam_lt]
  have hr : 0 < P.lam / (1 - P.lam) := div_pos P.hlam_pos hd
  have hsc : P.g_e P.e_L P.theta_H - P.g_e P.e_L P.theta_L < 0 := by
    linarith [P.h_single_crossing P.e_L]
  have h2 : P.lam / (1 - P.lam) * (P.g_e P.e_L P.theta_H - P.g_e P.e_L P.theta_L) < 0 :=
    mul_neg_of_pos_of_neg hr hsc
  have h1 : 0 < P.pi' P.e_L - P.g_e P.e_L P.theta_L := by linarith [P.h_foc]
  obtain heq | hlt := eq_or_lt_of_le h
  · have : P.pi' P.e_L - P.g_e P.e_L P.theta_L = 0 := by
      rw [← heq]; linarith [P.h_first_best]
    linarith
  · have := P.h_net_margin_decreasing P.e_star_L P.e_L hlt
    linarith [P.h_first_best]