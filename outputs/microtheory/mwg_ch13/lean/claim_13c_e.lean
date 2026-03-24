import Mathlib
open Topology

theorem claim_13C_e (θ_H θ_L : ℝ) (h : θ_H > θ_L) (p q : ℝ)
    (hpq : p < q) :
    p * θ_H + (1 - p) * θ_L < q * θ_H + (1 - q) * θ_L := by
  nlinarith