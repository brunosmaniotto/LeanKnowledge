import Mathlib

open Finset BigOperators
open Topology
open BigOperators

variable {S : Type*} [Fintype S] [DecidableEq S]

/-- A preference relation ≿ on state-contingent consumption bundles ℝ^S_+
    has an extended expected utility representation with respect to
    probabilities π if there exist state-dependent utility functions
    u_s : ℝ → ℝ such that x ≿ x' ↔ Σ_s π_s u_s(x_s) ≥ Σ_s π_s u_s(x'_s). -/
def HasExtendedExpectedUtilityRepr
    (pref : (S → ℝ) → (S → ℝ) → Prop)
    (π : S → ℝ) : Prop :=
  ∃ u : S → ℝ → ℝ, ∀ x x' : S → ℝ,
    pref x x' ↔
      ∑ s : S, π s * u s (x s) ≥ ∑ s : S, π s * u s (x' s)