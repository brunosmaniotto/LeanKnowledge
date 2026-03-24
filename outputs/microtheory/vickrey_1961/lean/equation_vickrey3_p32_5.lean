import Mathlib
open Topology

/-- The Pareto-optimality ODE condition -(v-x) + (v-x)·(dv/dx) = 0
    factors as (v-x)·(dv/dx - 1) = 0, so either v = x or dv/dx = 1. -/
theorem equation_Vickrey3_p32_5 (v x dvdx : ℝ) :
    (-(v - x) + (v - x) * dvdx = 0) ↔ (v = x ∨ dvdx = 1) := by
  have h : -(v - x) + (v - x) * dvdx = (v - x) * (dvdx - 1) := by ring
  rw [h, mul_eq_zero]
  simp [sub_eq_zero]