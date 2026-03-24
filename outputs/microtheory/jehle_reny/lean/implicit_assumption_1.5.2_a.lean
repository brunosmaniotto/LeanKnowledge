import Mathlib

open Topology

/-- Implicit Assumption 1.5.2(a): Assumption 1.2 (rational, continuous preferences
    representable by a utility function) is in effect, and all functions are
    freely differentiated — i.e., sufficient smoothness is assumed throughout. -/
structure SmoothUtilityAssumption (n : ℕ) where
  /-- The utility function u : ℝⁿ → ℝ representing the consumer's preferences. -/
  u : (Fin n → ℝ) → ℝ
  /-- u is continuous (from Assumption 1.2: continuous preference representation). -/
  u_continuous : Continuous u
  /-- u is infinitely differentiable (freely differentiate whenever necessary). -/
  u_smooth : ContDiff ℝ ⊤ u