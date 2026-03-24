import Mathlib
open Topology

theorem Equation_Vickrey3_p33_12
    (Z1 Z2 Z2' X : ℝ)
    (h : Z1 * Z2' = X) :
    Z1 * Z2' + Z2 = Z2 + X := by
  linarith