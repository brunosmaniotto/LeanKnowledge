import Mathlib

open scoped Real

-- Parameters for the market
variables (a b c : ℝ)

-- Assumptions on parameters
variable (ha_gt_c : a > c) (hc_gt_zero : c > 0) (hb_gt_zero : b > 0)

-- Inverse demand function p(q) = a - bq
def inverse_demand (q : ℝ) : ℝ := a - b * q

-- Marginal cost function. In this problem, c(q) = cq, so MC = c.