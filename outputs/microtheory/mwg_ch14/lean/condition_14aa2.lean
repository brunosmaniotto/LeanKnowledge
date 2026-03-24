import Mathlib

open MeasureTheory
open Topology

/-- The first-order approach (Condition 14.AA.2) replaces the full incentive
    compatibility constraint with the manager's first-order condition:
    ∫ v(w(π)) f_e(π|e) dπ - g'(e) = 0. -/
structure Condition_14AA2 where
  ProfitSpace : Type*
  meas : MeasurableSpace ProfitSpace
  mu : Measure ProfitSpace
  w : ProfitSpace → ℝ
  v : ℝ → ℝ
  e : ℝ
  f_e : ProfitSpace → ℝ → ℝ
  g_deriv : ℝ → ℝ
  foc : ∫ π, v (w π) * f_e π e ∂mu - g_deriv e = 0