import Mathlib
open Topology

/-- The second derivative of `f` at `x`, defined as the derivative of the
    derivative function: f''(x) = d/dx(f'(x)). -/
noncomputable def secondDeriv (f : ℝ → ℝ) (x : ℝ) : ℝ :=
  deriv (deriv f) x