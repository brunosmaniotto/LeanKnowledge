import Mathlib

open Set Filter
open Filter
open Topology

/-- Firm j's supply function: inverse of marginal cost above c_j'(0), zero below. -/
noncomputable def Implicit_Def_10C_e (c_j : ℝ → ℝ)
    (h_strict_convex : StrictConvexOn ℝ (Ici 0) c_j)
    (h_tendsto : Tendsto (deriv c_j) atTop atTop) :
    ℝ → ℝ := fun p =>
  if p < deriv c_j 0 then 0
  else Function.invFun (deriv c_j) p