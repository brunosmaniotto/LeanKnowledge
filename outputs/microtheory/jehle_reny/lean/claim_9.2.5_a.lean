import Mathlib

open Topology

theorem Claim_9_2_5_a (F : ℝ → ℝ) (f : ℝ → ℝ) (v : ℝ) (N : ℕ)
    (hF : HasDerivAt F (f v) v) :
    HasDerivAt (fun x => F x ^ N) (↑N * f v * F v ^ (N - 1)) v := by
  convert hF.pow N using 1
  ring