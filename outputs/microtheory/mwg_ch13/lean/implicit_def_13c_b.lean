import Mathlib
open Topology

/-- The single-crossing property for signaling models.
    The worker's MRS between wages and education is cₑ(e, θ),
    which is strictly decreasing in ability θ (since c_{eθ} < 0).
    This ensures indifference curves of different types cross at most once,
    with higher-ability workers having flatter curves at any crossing point. -/
structure SingleCrossingProperty where
  /-- Cost function c(e, θ) -/
  c : ℝ → ℝ → ℝ
  /-- Partial derivative of c with respect to education: cₑ(e, θ) = MRS -/
  c_e : ℝ → ℝ → ℝ
  /-- cₑ is the derivative of c w.r.t. its first argument -/
  is_partial_e : ∀ θ e : ℝ, HasDerivAt (c · θ) (c_e e θ) e
  /-- c_{eθ} < 0: the MRS is strictly decreasing in θ for every education level -/
  mrs_strict_anti : ∀ e : ℝ, StrictAnti (c_e e)