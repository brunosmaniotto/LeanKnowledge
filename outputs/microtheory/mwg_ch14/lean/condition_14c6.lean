import Mathlib

structure ObservableThetaContract where
  w_H : ℝ
  w_L : ℝ
  g_H : ℝ
  g_L : ℝ
  u_bar : ℝ
  v : ℝ → ℝ
  v' : ℝ → ℝ
  v'_injective : Function.Injective v'
  foc_equal : v' (w_H - g_H) = v' (w_L - g_L)
  pc_H : v (w_H - g_H) = u_bar
  pc_L : v (w_L - g_L) = u_bar

theorem Condition_14C6 (P : ObservableThetaContract) :
    P.w_H - P.g_H = P.w_L - P.g_L ∧
    P.v (P.w_H - P.g_H) = P.u_bar ∧
    P.v (P.w_L - P.g_L) = P.u_bar :=
  ⟨P.v'_injective P.foc_equal, P.pc_H, P.pc_L⟩