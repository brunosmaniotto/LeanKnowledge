import Mathlib
open Topology

theorem claim_vickrey3_p32_c (v x c : ℝ) (hv : v ≠ 0)
    (h : (1/2) * v ^ 2 = x * v + c) :
    x = v / 2 - c / v := by
  have hv2 : v ≠ 0 := hv
  field_simp at h ⊢
  nlinarith [sq_nonneg v]