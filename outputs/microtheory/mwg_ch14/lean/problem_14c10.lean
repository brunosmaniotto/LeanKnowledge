import Mathlib
open Topology

/-- Monopolistic screening problem (14.C.10): firm offers wage-task menu to two worker types. -/
structure MonopolisticScreeningProblem where
  /-- Profit from high type worker -/
  pi_H : ℝ → ℝ
  /-- Profit from low type worker -/
  pi_L : ℝ → ℝ
  /-- Disutility of task given type -/
  g : ℝ → ℝ → ℝ
  theta_H : ℝ
  theta_L : ℝ
  lam : ℝ
  u_bar : ℝ
  hlam_pos : 0 < lam
  hlam_lt : lam < 1
  /-- Menu: wage and task for each type -/
  w_H : ℝ
  t_H : ℝ
  w_L : ℝ
  t_L : ℝ
  hw_H : 0 ≤ w_H
  ht_H : 0 ≤ t_H
  hw_L : 0 ≤ w_L
  ht_L : 0 ≤ t_L
  /-- IR for low type -/
  ir_L : w_L - g t_L theta_L ≥ u_bar
  /-- IR for high type -/
  ir_H : w_H - g t_H theta_H ≥ u_bar
  /-- IC for high type: prefers own contract -/
  ic_H : w_H - g t_H theta_H ≥ w_L - g t_L theta_H
  /-- IC for low type: prefers own contract -/
  ic_L : w_L - g t_L theta_L ≥ w_H - g t_H theta_L

/-- The firm's objective: expected profit from the menu -/
noncomputable def MonopolisticScreeningProblem.objective (P : MonopolisticScreeningProblem) : ℝ :=
  P.lam * (P.pi_H P.t_H - P.w_H) + (1 - P.lam) * (P.pi_L P.t_L - P.w_L)