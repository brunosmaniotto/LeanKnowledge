import Mathlib

open scoped Classical
open Topology
open BigOperators

/-- The Original Position (Veil of Ignorance) framework.
    An individual chooses a social welfare criterion under uncertainty
    over which identity they will assume in society. -/
structure OriginalPosition (I : Type*) (S : Type*) where
  /-- A probability distribution over identities (must sum to 1 over individuals).
      Represents uncertainty about which person one will be. -/
  prob : I → ℝ
  prob_nonneg : ∀ i, 0 ≤ prob i
  /-- Utility that individual `i` receives in social state `s`. -/
  utility : I → S → ℝ
  /-- The social welfare criterion chosen from behind the veil:
      assigns a real-valued social welfare score to each social state
      by evaluating expected utility under identity uncertainty. -/
  evaluate : S → ℝ := fun s => ∑ᶠ i, prob i * utility i s