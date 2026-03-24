import Mathlib

open scoped Real

variables {q_j q_k c : ℝ}
variables {p : ℝ → ℝ}

-- Assume the inverse demand function p is differentiable at q_j + q_k.
variable (dp : DifferentiableAt ℝ p (q_j + q_k))

-- Define the profit function for firm j.
def profit_j (q : ℝ) : ℝ := p (q + q_k) * q - c * q