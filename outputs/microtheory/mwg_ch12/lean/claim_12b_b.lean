import Mathlib

-- Assume p and c are differentiable functions from ℝ to ℝ
variables (p c : ℝ → ℝ)
variables (hp : Differentiable ℝ p) (hc : Differentiable ℝ c)
variables (q : ℝ)

open scoped Real
open Topology

-- The monopolist's first-order condition for profit maximization
-- Profit π(q) = p(q) * q - c(q)
-- π'(q) = p'(q) * q + p(q) * (deriv of q with respect to q) - c'(q)
--       = p'(q) * q + p(q) * 1 - c'(q)
-- Monopolist's FOC: p'(q) * q + p(q) - c'(q) = 0
def monopolist_foc (q : ℝ) : Prop :=
  deriv p q * q + p q = deriv c q

-- The competitive firm's condition (price equals marginal cost)