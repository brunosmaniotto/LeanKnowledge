import Mathlib

open MeasureTheory
open Topology

/-- Problem 14.AA.1: Optimal contract for implementing a specific effort choice
    from a general finite set of feasible efforts. The principal minimizes expected
    wage cost subject to participation (PC) and incentive compatibility (IC) constraints.
    With K possible actions, the IC constraint consists of (K-1) constraints. -/
structure GeneralEffortContract (K : ℕ) (hK : K ≥ 1) where
  /-- The finite set of feasible effort choices, indexed by Fin K -/
  efforts : Fin K → ℝ
  /-- The effort level to be implemented (index into efforts) -/
  target : Fin K
  /-- Wage as a function of profit realization -/
  wage : ℝ → ℝ
  /-- Density of profit given effort: f(π | e) -/
  density : ℝ → ℝ → ℝ
  /-- Worker's utility of income: v(w) -/
  v : ℝ → ℝ
  /-- Worker's cost of effort: g(e) -/
  g : ℝ → ℝ
  /-- Worker's reservation utility ū -/
  u_bar : ℝ
  /-- Densities are nonneg -/
  density_nonneg : ∀ π e, 0 ≤ density π e
  /-- Participation constraint (PC):
      ∫ v(w(π)) f(π|e) dπ - g(e) ≥ ū -/
  pc : ∫ π, v (wage π) * density π (efforts target) ≥ g (efforts target) + u_bar
  /-- Incentive compatibility (IC): for every alternative effort ê,
      the target effort yields at least as high expected utility.
      This gives (K-1) constraints. -/
  ic : ∀ j : Fin K, j ≠ target →
    ∫ π, v (wage π) * density π (efforts target) - g (efforts target) ≥
    ∫ π, v (wage π) * density π (efforts j) - g (efforts j)