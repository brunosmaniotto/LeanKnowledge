import Mathlib
open Topology

theorem equation_vickrey3_p33_16
    (x a k Z₂ Z₂' : ℝ)
    (hq : x ^ 2 - a * x + k ≠ 0) :
    (x ^ 2 - a * x + k) * (Z₂' + 1) = Z₂ * (Z₂ + x) ↔
    Z₂' = Z₂ * (Z₂ + x) / (x ^ 2 - a * x + k) - 1 := by
  rw [mul_comm (x ^ 2 - a * x + k) (Z₂' + 1)]
  constructor
  · intro h
    rw [eq_sub_iff_add_eq, eq_div_iff hq]
    exact h
  · intro h
    rw [eq_sub_iff_add_eq, eq_div_iff hq] at h
    exact h