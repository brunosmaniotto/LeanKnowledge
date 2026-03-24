import Mathlib

noncomputable section

structure ObservableTypeProblem where
  lam : ℝ
  hlam_pos : 0 < lam
  hlam_lt : lam < 1
  pi_fn : ℝ → ℝ
  v : ℝ → ℝ
  g : ℝ → ℝ → ℝ
  theta_H : ℝ
  theta_L : ℝ
  u_bar : ℝ

structure ObservableTypeContract where
  w_H : ℝ
  e_H : ℝ
  w_L : ℝ
  e_L : ℝ
  hw_H : 0 ≤ w_H
  he_H : 0 ≤ e_H
  hw_L : 0 ≤ w_L
  he_L : 0 ≤ e_L

def ObservableTypeProblem.objective (P : ObservableTypeProblem)
    (c : ObservableTypeContract) : ℝ :=
  P.lam * (P.pi_fn c.e_H - c.w_H) + (1 - P.lam) * (P.pi_fn c.e_L - c.w_L)