import Mathlib
open Topology

theorem equation_vickrey3_p33_20
    {F : Type*} [Field F]
    (a x k v1 : F)
    (hv1 : v1 ≠ 0)
    (h : (a - x) * v1 = k) :
    x = a - k / v1 := by
  have h1 : a - x = k / v1 := by
    rw [eq_div_iff hv1]
    exact h
  linear_combination -h1