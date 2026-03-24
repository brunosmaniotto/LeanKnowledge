import Mathlib

noncomputable section

structure PAModel where
  v : ℝ → ℝ
  v_inv : ℝ → ℝ
  g : ℝ → ℝ
  u_bar : ℝ
  E_profit : ℝ → ℝ
  v_inv_right : ∀ y, v (v_inv y) = y

def PAModel.optimalWage (m : PAModel) (e : ℝ) : ℝ :=
  m.v_inv (m.u_bar + m.g e)