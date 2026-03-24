import Mathlib

open Real

-- Define the functions for the example ODE: (3x² + y) + (x³ + x) y' = 0
def M : ℝ × ℝ → ℝ := λ (x, y) => 3 * x ^ 2 + y