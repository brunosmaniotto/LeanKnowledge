import Mathlib
open Topology

-- Fig 7.39 is a game where no strategy profile can be a Nash equilibrium
-- in every subgame simultaneously, hence no SPNE exists.

theorem Exercise_7_40_c
    {Strategy : Type*}
    {Subgame : Type*}
    (isNashIn : Strategy → Subgame → Prop)
    (isSubgamePerfect : Strategy → Prop)
    (h_spne_def : ∀ s, isSubgamePerfect s ↔ ∀ g : Subgame, isNashIn s g)
    (h_no_universal_nash : ∀ s : Strategy, ∃ g : Subgame, ¬isNashIn s g) :
    ∀ s, ¬isSubgamePerfect s := by
  intro s hs
  rw [h_spne_def] at hs
  obtain ⟨g, hg⟩ := h_no_universal_nash s
  exact hg (hs g)