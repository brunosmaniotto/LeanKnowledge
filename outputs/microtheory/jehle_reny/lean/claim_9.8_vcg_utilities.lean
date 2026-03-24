import Mathlib

open intervalIntegral
open Topology

theorem Claim_9_8_VCG_utility (t : ℝ) (h0 : 0 ≤ t) (h1 : t ≤ 1) :
    (∫ s in (0 : ℝ)..t, t) - (1/2 : ℝ) * t ^ 2 = (1/2 : ℝ) * t ^ 2 := by
  rw [integral_const, sub_zero, smul_eq_mul]
  ring