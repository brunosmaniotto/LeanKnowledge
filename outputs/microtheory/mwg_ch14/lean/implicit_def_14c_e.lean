import Mathlib
open Topology

/-- Infinite risk aversion: the manager's expected utility equals his lowest utility
level across states. Participation requires utility ≥ ū in each state. -/
structure InfiniteRiskAversion (v_H v_L u_bar : ℝ) (prob : ℝ) where
  /-- Probability weight is in (0,1) -/
  hprob_pos : 0 < prob
  hprob_lt : prob < 1
  /-- Expected utility under infinite risk aversion equals the minimum -/
  expected_eq_min : prob * v_H + (1 - prob) * v_L = min v_H v_L
  /-- Participation constraint: utility in high state ≥ ū -/
  pc_high : v_H ≥ u_bar
  /-- Participation constraint: utility in low state ≥ ū -/
  pc_low : v_L ≥ u_bar