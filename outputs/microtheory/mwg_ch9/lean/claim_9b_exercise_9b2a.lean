import Mathlib
open Topology

-- We model this as a pure logical statement about the relationship
-- between Nash equilibria and subgame perfect equilibria.
-- A strategy profile is subgame perfect iff it is a Nash equilibrium
-- in every subgame. If the only subgame is the game itself,
-- this reduces to just being a Nash equilibrium.

theorem Claim_9B_Exercise_9B2a
    {Strategy : Type*}
    {Subgame : Type*}
    (whole : Subgame)
    (isNashIn : Strategy → Subgame → Prop)
    (isSubgamePerfect : Strategy → Prop)
    (h_spne_def : ∀ s, isSubgamePerfect s ↔ ∀ g : Subgame, isNashIn s g)
    (h_only_subgame : ∀ g : Subgame, g = whole)
    (s : Strategy)
    (h_nash : isNashIn s whole) :
    isSubgamePerfect s := by
  rw [h_spne_def]
  intro g
  rw [h_only_subgame g]
  exact h_nash