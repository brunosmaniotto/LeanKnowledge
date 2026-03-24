import Mathlib

/-- The monetary steady state is the steady-state equilibrium (y, 1 − y) in which
the price sequence p_t is constant and therefore the real value of money remains
constant and positive. This is the analog of the golden rule. -/
structure MonetarySteadyState where
  /-- The steady-state allocation parameter y ∈ (0, 1) -/
  y : ℝ
  /-- The constant price level -/
  p : ℝ
  hy_pos : 0 < y
  hy_lt : y < 1
  hp_pos : 0 < p