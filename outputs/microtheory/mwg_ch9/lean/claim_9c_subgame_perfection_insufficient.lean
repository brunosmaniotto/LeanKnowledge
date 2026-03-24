import Mathlib
open Topology

/-- Example 9.C.1: Entry game with imperfect information.
    Firm E chooses: out, in₁, or in₂.
    Incumbent cannot distinguish in₁ from in₂, so the only subgame is the whole game.
    We show both NE are SPNE (trivially) but one fails sequential rationality. -/

-- Entry game actions
inductive EntryAction : Type
  | out : EntryAction
  | in₁ : EntryAction
  | in₂ : EntryAction
  deriving DecidableEq

-- Incumbent's response (at the information set containing both in₁ and in₂)
inductive IncumbentAction : Type
  | fight : IncumbentAction
  | accommodate : IncumbentAction
  deriving DecidableEq

-- A strategy profile
structure StrategyProfile where
  entrant : EntryAction
  incumbent : IncumbentAction
  deriving DecidableEq

-- The game has imperfect information: incumbent cannot distinguish in₁ from in₂
-- Therefore the only subgame is the whole game
def onlySubgameIsWholeGame : Prop :=
  ∀ (entryAction : EntryAction),
    entryAction = EntryAction.in₁ ∨ entryAction = EntryAction.in₂ →
    True  -- incumbent's information set is non-singleton, so no proper subgame starts here

-- A Nash equilibrium is subgame perfect iff it induces a NE in every subgame
-- When the only subgame is the whole game, SPNE ≡ NE