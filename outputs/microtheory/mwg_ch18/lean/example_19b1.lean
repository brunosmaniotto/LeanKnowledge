import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Expected utility evaluation for contingent commodity vectors.
    Given S states and L commodities, consumer i evaluates contingent plans
    by comparing expected utilities: Σ_s π_si · u_si(x_si). -/
noncomputable def expected_utility
    (S : Finset ι) -- set of states
    (π : ι → ℝ) -- probability of each state (π_si)
    (u : ι → (Fin L → ℝ) → ℝ) -- state-dependent Bernoulli utility u_si
    (x : ι → Fin L → ℝ) -- contingent commodity vector (x_lsi for each state s)
    : ℝ :=
  ∑ s ∈ S, π s * u s (x s)

/-- Consumer i prefers contingent commodity vector x over x' iff
    expected utility of x is at least that of x'. -/
noncomputable def expected_utility_prefers
    (S : Finset ι) (π : ι → ℝ) (u : ι → (Fin L → ℝ) → ℝ)
    (x x' : ι → Fin L → ℝ) : Prop :=
  expected_utility S π u x ≥ expected_utility S π u x'