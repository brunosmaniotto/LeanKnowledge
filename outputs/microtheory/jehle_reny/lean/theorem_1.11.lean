import Mathlib

open BigOperators
open Topology

/-- The Slutsky equation: the effect of a price change on Marshallian demand
    decomposes into a substitution effect and an income effect. -/
theorem slutsky_equation
    {n : ℕ}
    (i j : Fin n)
    (dx_dp : ℝ)      -- ∂xᵢ(p,y)/∂pⱼ
    (dx_dy : ℝ)      -- ∂xᵢ(p,y)/∂y
    (dxh_dp : ℝ)     -- ∂xᵢʰ(p,u*)/∂pⱼ
    (xj : ℝ)         -- xⱼ(p,y)
    (de_dp : ℝ)      -- ∂e(p,u*)/∂pⱼ
    -- Chain rule on xᵢʰ(p,u*) = xᵢ(p, e(p,u*))
    (chain_rule : dxh_dp = dx_dp + dx_dy * de_dp)
    -- Shephard's lemma: ∂e/∂pⱼ = xⱼ(p,y)
    (shephard : de_dp = xj) :
    dx_dp = dxh_dp - xj * dx_dy := by
  rw [shephard] at chain_rule
  linarith [mul_comm dx_dy xj]