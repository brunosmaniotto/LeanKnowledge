import Mathlib
open Topology

/-- Vickrey (1961) p.32, eq. 6: the Pareto-optimality FOC with uniform density
    1/(b−a) vanishes iff the density-free condition (v−a) + (v−x)·v' = 0 holds. -/
theorem equation_vickrey3_p32_6
    (v x a b v' : ℝ) (hab : b ≠ a) :
    1 / (b - a) * (v - a) + (v - x) * (1 / (b - a)) * v' = 0 ↔
    v - a + (v - x) * v' = 0 := by
  have hab' : (b - a) ≠ 0 := sub_ne_zero.mpr hab
  set c := (1 : ℝ) / (b - a)
  have hc : c ≠ 0 := div_ne_zero one_ne_zero hab'
  have factored : c * (v - a) + (v - x) * c * v' = c * (v - a + (v - x) * v') := by ring
  constructor
  · intro h; rw [factored] at h; exact (mul_eq_zero.mp h).resolve_left hc
  · intro h; rw [factored, h, mul_zero]