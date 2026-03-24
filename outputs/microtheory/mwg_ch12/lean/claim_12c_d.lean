import Mathlib

open Real Function -- Open Function for deriv, Real for basic real number properties
open Topology

-- Define the context: price function, cost, quantities
-- We work with real numbers for quantities and prices.
variable (p : ℝ → ℝ) (c : ℝ)
variable (q1_star q2_star : ℝ) -- Nash equilibrium quantities

-- Assumptions about the price function
variable (hp_diff : Differentiable ℝ p) -- p is differentiable everywhere
variable (hp_deriv_neg : ∀ q, deriv p q < 0) -- Strictly decreasing price function
variable (hp_pos_at_zero : p 0 > c) -- Demand exists at zero quantity, price exceeds cost

-- Nash equilibrium conditions for Cournot duopoly with equal costs.
-- NE_cond1_pos: If q1_star > 0, firm 1's FOC holds with equality.
variable (NE_cond1_pos : q1_star > 0 → deriv p (q1_star + q2_star) * q1_star + p (q1_star + q2_star) = c)
-- NE_cond1_zero: If q1_star = 0, firm 1's FOC implies p(q2_star) ≤ c.
variable (NE_cond1_zero : q1_star = 0 → p q2_star ≤ c)
-- NE_cond2_pos: If q2_star > 0, firm 2's FOC holds with equality.
variable (NE_cond2_pos : q2_star > 0 → deriv p (q1_star + q2_star) * q2_star + p (q1_star + q2_star) = c)
-- NE_cond2_zero: If q2_star = 0, firm 2's FOC implies p(q1_star) ≤ c.
variable (NE_cond2_zero : q2_star = 0 → p q1_star ≤ c)

-- Quantities must be non-negative in an economic context.
variable (q1_nonneg : q1_star ≥ 0)
variable (q2_nonneg : q2_star ≥ 0)

-- Helper lemma: the product of a negative number and a positive number is negative.
lemma deriv_neg_mul_pos {y : ℝ} (h_deriv_neg : deriv p y < 0) (h_pos : x > 0) : deriv p y * x < 0 :=
  mul_neg_of_neg_of_pos h_deriv_neg h_pos