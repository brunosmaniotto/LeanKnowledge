import Mathlib

/-- A VNM utility function for risk aversion analysis (Section 2.4.3):
    a differentiable real-valued function with strictly positive derivative
    at all nonnegative wealth levels. -/
structure VNMUtility where
  /-- The utility function u : ℝ → ℝ -/
  u : ℝ → ℝ
  /-- u is differentiable on all of ℝ -/
  u_differentiable : Differentiable ℝ u
  /-- u′(w) > 0 for all w ≥ 0 -/
  u_deriv_pos : ∀ w : ℝ, 0 ≤ w → deriv u w > 0