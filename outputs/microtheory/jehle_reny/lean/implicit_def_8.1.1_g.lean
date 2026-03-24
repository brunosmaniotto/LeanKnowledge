import Mathlib
open Topology

/-- The insurance purchase threshold function h(p) = [u(w) − u(w − p)] / [u(w) − u(w − L)].
    A consumer with accident probability π buys insurance at price p iff π ≥ h(p). -/
noncomputable def insuranceThreshold
    (u : ℝ → ℝ) (w L p : ℝ) : ℝ :=
  (u w - u (w - p)) / (u w - u (w - L))

/-- A consumer with utility u, wealth w, loss L, and accident probability π
    purchases insurance at price p if and only if π ≥ h(p). -/
def purchasesInsurance
    (u : ℝ → ℝ) (w L : ℝ) (π p : ℝ) : Prop :=
  π ≥ insuranceThreshold u w L p