import Mathlib
open Topology

-- In extensive-form games with imperfect information, sequential rationality
-- at every information set does not imply subgame perfection (or even Nash equilibrium).
-- The matching pennies game (Fig. 7.34) provides a concrete example.

theorem Claim_7_4_SR_d
    {Strategy : Type*}
    (isSequentiallyRational : Strategy → Prop)
    (isSubgamePerfect : Strategy → Prop)
    (isNashEquilibrium : Strategy → Prop)
    (h_spne_implies_nash : ∀ s, isSubgamePerfect s → isNashEquilibrium s)
    (s : Strategy)
    (h_seq_rational : isSequentiallyRational s)
    (h_not_nash : ¬ isNashEquilibrium s) :
    isSequentiallyRational s ∧ ¬ isSubgamePerfect s ∧ ¬ isNashEquilibrium s := by
  exact ⟨h_seq_rational, fun h => h_not_nash (h_spne_implies_nash s h), h_not_nash⟩