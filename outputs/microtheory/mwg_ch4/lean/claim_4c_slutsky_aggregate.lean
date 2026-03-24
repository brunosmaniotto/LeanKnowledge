import Mathlib

open Matrix Finset BigOperators
open Topology
open BigOperators

/-- The Slutsky equation for aggregate demand: the substitution matrix decomposes
    into the price derivative plus the wealth-weighted income effects. -/
theorem slutsky_aggregate_demand
    {n m : ℕ}
    (x : Fin n → ℝ)                          -- aggregate demand vector
    (Dp_x : Matrix (Fin n) (Fin n) ℝ)        -- price Jacobian of aggregate demand
    (Dw_x : Fin n → ℝ)                       -- wealth derivative of aggregate demand
    (α : Fin m → ℝ)                           -- wealth share of consumer i
    (x_i : Fin m → Fin n → ℝ)                -- individual demand vectors
    (Dw_i : Fin m → Fin n → ℝ)               -- individual wealth derivatives
    (h_agg : x = ∑ i, x_i i)                 -- aggregate demand is sum of individual demands
    (h_Dw : Dw_x = ∑ i, α i • Dw_i i)       -- aggregate wealth effect
    (S : Matrix (Fin n) (Fin n) ℝ)           -- Slutsky matrix
    (h_S : S = Dp_x + vecMulVec Dw_x x)     -- Slutsky equation: S = Dp + Dw · x^T
    : S = Dp_x + vecMulVec (∑ i, α i • Dw_i i) x := by
  rw [h_S, h_Dw]