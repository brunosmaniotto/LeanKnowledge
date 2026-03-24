import Mathlib
open scoped symmDiff
open Topology

theorem compensated_demand_own_price
    (Δp_l Δx_l : ℝ)
    (h_dot : Δp_l * Δx_l ≤ 0)
    (h_pos : Δp_l > 0) :
    Δx_l ≤ 0 := by
  by_contra h
  push_neg at h
  have : Δp_l * Δx_l > 0 := mul_pos h_pos h
  linarith