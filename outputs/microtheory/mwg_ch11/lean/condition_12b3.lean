import Mathlib

open Set Filter Topology

-- We mark definitions involving `deriv` as `noncomputable` as `deriv` itself is noncomputable.
noncomputable section

variables {p c : ℝ → ℝ} {q_m : ℝ}

-- Hypotheses: p and c are differentiable everywhere on ℝ.
variable (hp : Differentiable ℝ p) (hc : Differentiable ℝ c)

-- Define total revenue, total cost, and profit functions.
def total_revenue (p : ℝ → ℝ) (q : ℝ) : ℝ := p q * q