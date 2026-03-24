import Mathlib
open Topology

theorem giffen_implies_inferior
    (dp dw x s_ll : ℝ)
    (h_slutsky : s_ll = dp + dw * x)
    (h_neg_semi : s_ll ≤ 0)
    (h_giffen : dp > 0)
    (h_consumption : x ≥ 0) :
    dw < 0 := by
  by_contra h
  push_neg at h
  nlinarith [mul_nonneg h h_consumption]