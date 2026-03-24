import Mathlib
open Topology

-- We model the manager's optimal contract wage determination.
-- v is a strictly monotone utility function, g is disutility of effort.
-- The participation constraint is: v(w) - g(e) = ū, i.e., v(w) = ū + g(e).
-- Since v is strictly monotone, higher g(e) requires higher w.

theorem Claim_14B_c
    {v : ℝ → ℝ} {g_H g_L w_H w_L ubar : ℝ}
    (hv_strict_mono : StrictMono v)
    (h_gH_gt_gL : g_H > g_L)
    (h_pc_H : v w_H = ubar + g_H)
    (h_pc_L : v w_L = ubar + g_L) :
    w_H > w_L := by
  apply hv_strict_mono.lt_iff_lt.mp
  linarith