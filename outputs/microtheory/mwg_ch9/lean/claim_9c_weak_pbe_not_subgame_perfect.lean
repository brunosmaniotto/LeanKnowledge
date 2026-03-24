import Mathlib
open Topology

-- Model the entry game from MWG Example 9.B.3
-- Players: E (entrant), I (incumbent)
-- E moves: Out, In; if In, E chooses Fight_E or Accommodate_E
-- I moves (if E plays In): Fight_I or Accommodate_I

inductive Player : Type where
  | E | I
  deriving DecidableEq

inductive MoveE : Type where
  | Out | In
  deriving DecidableEq

inductive PostEntryE : Type where
  | Fight | Accommodate
  deriving DecidableEq

inductive MoveI : Type where
  | Fight | Accommodate
  deriving DecidableEq

-- A strategy profile: E's entry decision, E's post-entry action, I's action
structure StrategyProfile where
  entryDecision : MoveE
  postEntryE : PostEntryE
  actionI : MoveI
  deriving DecidableEq

-- Belief: probability I assigns to E having played Fight (in [0,1])
-- We represent as a rational for simplicity
structure Belief where
  probFight : ℚ
  valid : 0 ≤ probFight ∧ probFight ≤ 1

-- Payoffs in the post-entry subgame (E, I):
-- (Fight, Fight) → (0, 0)
-- (Fight, Accommodate) → (2, 1)
-- (Accommodate, Fight) → (1, 0)
-- (Accommodate, Accommodate) → (3, 2)
def payoffE (pe : PostEntryE) (mi : MoveI) : ℤ :=
  match pe, mi with
  | PostEntryE.Fight, MoveI.Fight => 0
  | PostEntryE.Fight, MoveI.Accommodate => 2
  | PostEntryE.Accommodate, MoveI.Fight => 1
  | PostEntryE.Accommodate, MoveI.Accommodate => 3