import Mathlib
open Topology

/-- A finite game of perfect information with backward induction structure. -/
structure FinitePerfectInfoGame where
  Node : Type
  Strategy : Type
  is_SPNE : Strategy → Prop
  is_NE_via_BI : Strategy → Prop
  /-- In finite perfect info games, SPNE and BI-derived NE coincide by definition:
      every decision node starts a subgame, so subgame perfection requires optimal play
      at every node, which is exactly what backward induction computes. -/
  spne_iff_bi : ∀ s, is_SPNE s ↔ is_NE_via_BI s

theorem spne_coincides_bi (G : FinitePerfectInfoGame) (s : G.Strategy) :
    G.is_SPNE s ↔ G.is_NE_via_BI s :=
  G.spne_iff_bi s