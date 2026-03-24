import Mathlib
open Topology

-- Minimal axiomatized framework for extensive-form games
variable {Game : Type} {Strategy : Type} {Player : Type}

-- A subgame is identified by a node; the full game is a subgame of itself
variable (isSubgame : Game → Game → Prop)
variable (isNE : Game → Strategy → Prop)
variable (fullGame : Game)

-- SPNE: a strategy profile is SPNE if it induces a NE in every subgame
def isSPNE (isSubgame : Game → Game → Prop) (isNE : Game → Strategy → Prop)
    (fullGame : Game) (s : Strategy) : Prop :=
  ∀ g : Game, isSubgame g fullGame → isNE g s

-- The full game is a subgame of itself (Definition 9.B.1)
variable (fullGame_is_subgame : isSubgame fullGame fullGame)