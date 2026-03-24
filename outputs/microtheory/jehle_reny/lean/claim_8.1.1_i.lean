import Mathlib
open Topology

/-- The conditional expectation E[π | π ≥ t] as a function of threshold t -/
axiom condExpGe : ℝ → ℝ
/-- E[π | π ≥ t] is non-decreasing in t (higher threshold → higher conditional mean) -/
axiom condExpGe_monotone : Monotone condExpGe

/-- h(p) is the threshold function, strictly increasing in the price p -/
axiom h_threshold : ℝ → ℝ
axiom h_threshold_strictMono : StrictMono h_threshold

/-- g(p) = E[π | π ≥ h(p)] -/
noncomputable def g_func (p : ℝ) : ℝ := condExpGe (h_threshold p)

/-- g is non-decreasing in p: higher p raises h(p) (strict mono),
    which raises the conditional expectation (monotone). -/
theorem Claim_8_1_1_i : Monotone g_func := by
  intro a b hab
  unfold g_func
  exact condExpGe_monotone (h_threshold_strictMono.monotone hab)