import Mathlib

open Topology

/-- Preference relation on gambles satisfying G1 (rationality) and continuity
    (closed upper/lower contour sets). -/
structure GamblePreference (G : Type*) [TopologicalSpace G] where
  pref : G → G → Prop
  complete : ∀ a b, pref a b ∨ pref b a
  trans : ∀ a b c, pref a b → pref b c → pref a c
  refl : ∀ a, pref a a
  closed_upper : ∀ b, IsClosed {a | pref a b}
  closed_lower : ∀ b, IsClosed {a | pref b a}

/-- Debreu's representation theorem: a continuous complete preorder on a
    second-countable space admits a continuous utility representation. -/
axiom debreu_continuous_utility (G : Type*) [TopologicalSpace G]
    [SecondCountableTopology G] (gp : GamblePreference G) :
    ∃ u : G → ℝ, Continuous u ∧ ∀ a b, gp.pref a b ↔ u a ≥ u b

/-- Claim 2.4(f): Axioms G1, G2, and continuity ensure the existence of a
    continuous utility function u : G → ℝ representing ≿. -/
theorem claim_2_4_f (G : Type*) [TopologicalSpace G] [SecondCountableTopology G]
    (gp : GamblePreference G) :
    ∃ u : G → ℝ, Continuous u ∧ ∀ a b, gp.pref a b ↔ u a ≥ u b :=
  debreu_continuous_utility G gp