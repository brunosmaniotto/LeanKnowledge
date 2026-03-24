import Mathlib

/-- MWG Definition A2.1.1(b): The derivative of f at x, f'(x) = dy/dx,
    giving the instantaneous rate of change of f(x). -/
noncomputable abbrev MWG.derivative (f : ℝ → ℝ) (x : ℝ) : ℝ := deriv f x