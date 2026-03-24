import Mathlib

structure Contract where
  w_L : ℝ
  e_L : ℝ
  w_H : ℝ
  e_H : ℝ

structure ProblemData where
  g : ℝ → ℝ → ℝ
  v_inv_u_bar : ℝ
  theta_L : ℝ
  profit : Contract → ℝ
  h_profit_shift : ∀ c : Contract, ∀ eps : ℝ,
    profit { w_L := c.w_L - eps, e_L := c.e_L, w_H := c.w_H - eps, e_H := c.e_H } =
    profit c + eps

def pc_slack (P : ProblemData) (c : Contract) : ℝ :=
  c.w_L - P.g c.e_L P.theta_L - P.v_inv_u_bar