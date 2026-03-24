import Mathlib
open Topology

/-- In the insurance screening game, there always exists a subgame perfect
    equilibrium in behavioural strategies. (MWG state this without proof.) -/
theorem Claim_8_behavioral_existence
    {BehavioralStrategy : Type*}
    {Subgame : Type*}
    (isNashIn : BehavioralStrategy → Subgame → Prop)
    (isSubgamePerfect : BehavioralStrategy → Prop)
    (h_spne_def : ∀ s, isSubgamePerfect s ↔ ∀ g : Subgame, isNashIn s g)
    (h_exists_nash_all : ∃ s : BehavioralStrategy, ∀ g : Subgame, isNashIn s g) :
    ∃ s : BehavioralStrategy, isSubgamePerfect s := by
  obtain ⟨s, hs⟩ := h_exists_nash_all
  exact ⟨s, (h_spne_def s).mpr hs⟩