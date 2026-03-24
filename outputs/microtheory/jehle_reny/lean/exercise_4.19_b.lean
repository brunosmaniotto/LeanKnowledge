import Mathlib

open Real

/-- For utility u(x, m) = ln(x) + m with Marshallian demands x* = 1/p, m* = y - 1,
    the indirect utility function is v(p, y) = -ln(p) + y - 1. -/
theorem Exercise_4_19_b (p y : ℝ) (hp : 0 < p) :
    log (1 / p) + (y - 1) = -log p + y - 1 := by
  rw [one_div, log_inv]
  ring