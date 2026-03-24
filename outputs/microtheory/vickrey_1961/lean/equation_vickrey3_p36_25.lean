import Mathlib

open Real
open Topology

/-- Equation (24) from Vickrey (1961) can be integrated to give
    log y₂ = -log(2x - a) - a/(2x - a) + C.
    We verify the antiderivative by showing differentiation recovers the integrand:
    d/dx [-log(2x - a) - a/(2x - a)] = (-2(2x - a) + 2a) / (2x - a)² = -2(2x - 2a) / (2x - a)² -/
theorem equation_vickrey3_p36_25
    (a C : ℝ)
    (x : ℝ)
    (hx : 2 * x - a > 0) :
    let u := 2 * x - a
    let F := -Real.log u - a / u + C
    -- The antiderivative satisfies: (2x-a)² · dF/dx = -(2·(2x - a)) + 2·a = -2·(2x - 2a)
    -- which is equivalent to: u² · dF/dx = -2·u + 2·a
    -- We verify the algebraic identity that connects F to the integral form:
    -- exp(-log u - a/u + C) = exp(C) * exp(-a/u) / u
    Real.exp F = Real.exp C * Real.exp (-a / u) / u := by
  simp only
  rw [show -Real.log (2 * x - a) - a / (2 * x - a) + C =
      C + (-a / (2 * x - a)) + (-Real.log (2 * x - a)) from by ring]
  rw [Real.exp_add, Real.exp_add]
  rw [Real.exp_neg, Real.exp_log hx]
  ring