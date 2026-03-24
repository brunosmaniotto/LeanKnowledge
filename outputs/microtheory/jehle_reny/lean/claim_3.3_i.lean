import Mathlib

open Set
open Topology

/-- When fixed inputs are chosen optimally, the first-order conditions require
    the partial derivative of short-run cost with respect to each fixed input to be zero. -/
theorem Claim_3_3_i
    {m : ℕ}
    (sc : (Fin m → ℝ) → ℝ)
    (x_bar : Fin m → ℝ)
    (hmin : IsLocalMin sc x_bar) :
    fderiv ℝ sc x_bar = 0 :=
  hmin.fderiv_eq_zero