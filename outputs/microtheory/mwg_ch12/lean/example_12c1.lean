import Mathlib
open Topology

/-!
# Cournot Duopoly Theorem

This module formalizes a theorem regarding a Cournot duopoly with specific cost and demand functions.
It proves the best-response function, unique Nash equilibrium quantities, total output, market price
and its bounds, and the symmetric joint monopoly point.
-/

section CournotDuopoly

-- Parameters for the Cournot model
variable (a b c : ℝ)

-- Assumptions on parameters
variable (h_a_gt_c : a > c)
variable (h_c_gt_0 : c > 0)
variable (h_b_gt_0 : b > 0)

-- Inverse demand function
def p (q : ℝ) := a - b * q

/-!
## Firm j's Best-Response Function

Firm j's best-response function is `b_j(q_k) = max{0, (a - c - bq_k)/2b}`.
We define this function and prove later properties based on it.
-/

-- Interior solution for best response