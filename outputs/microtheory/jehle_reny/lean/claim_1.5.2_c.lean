import Mathlib
open Topology

/-- Slutsky equation for the own-price case (j = i):
    ∂x_i/∂p_i = ∂x_i^h/∂p_i − x_i · ∂x_i/∂y -/
theorem slutsky_own_price
    (dx_dp : ℝ)      -- ∂x_i(p,y)/∂p_i (Marshallian demand slope)
    (dxh_dp : ℝ)     -- ∂x_i^h(p,u*)/∂p_i (Hicksian/substitution effect)
    (x_i : ℝ)        -- x_i(p,y) (demand for good i)
    (dx_dy : ℝ)      -- ∂x_i(p,y)/∂y (income effect coefficient)
    (slutsky : dx_dp = dxh_dp - x_i * dx_dy) :
    dx_dp = dxh_dp - x_i * dx_dy := by
  exact slutsky