import Mathlib

open Matrix
open Topology

/-- The wealth effect matrix D_w x_i(p, p·ω_i) z_i(p)^T is an outer product of two vectors,
    hence has rank at most 1. This means the wealth effect can hurt in at most one direction. -/
theorem wealth_effect_rank_one {n : ℕ} (Dw_x : Fin n → ℝ) (z : Fin n → ℝ) :
    (vecMulVec Dw_x z).rank ≤ 1 := by
  exact rank_vecMulVec_le Dw_x z