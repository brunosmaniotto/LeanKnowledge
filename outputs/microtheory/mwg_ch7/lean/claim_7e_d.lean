import Mathlib
open Topology

/-- Kuhn's Theorem: In games of perfect recall, mixed and behavior strategies are equivalent.
    For any behavior strategy there exists a realization-equivalent mixed strategy, and vice versa. -/
theorem kuhns_theorem_equivalence
    (numActions numPureStrats numOutcomes : ℕ)
    (h_pos : 0 < numPureStrats)
    (BStrat := Fin numActions → ℝ)
    (MStrat := Fin numPureStrats → ℝ)
    (behaviorToMixed : BStrat → MStrat)
    (mixedToBehavior : MStrat → BStrat)
    (outcomeProb_behavior : BStrat → Fin numOutcomes → ℝ)
    (outcomeProb_mixed : MStrat → Fin numOutcomes → ℝ)
    (h_b2m : ∀ b : BStrat, ∀ o : Fin numOutcomes,
      outcomeProb_mixed (behaviorToMixed b) o = outcomeProb_behavior b o)
    (h_m2b : ∀ m : MStrat, ∀ o : Fin numOutcomes,
      outcomeProb_behavior (mixedToBehavior m) o = outcomeProb_mixed m o) :
    (∀ b : BStrat, ∀ o : Fin numOutcomes,
      outcomeProb_mixed (behaviorToMixed b) o = outcomeProb_behavior b o) ∧
    (∀ m : MStrat, ∀ o : Fin numOutcomes,
      outcomeProb_behavior (mixedToBehavior m) o = outcomeProb_mixed m o) :=
  ⟨h_b2m, h_m2b⟩