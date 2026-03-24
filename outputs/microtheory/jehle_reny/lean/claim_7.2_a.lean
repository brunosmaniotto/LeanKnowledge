import Mathlib
open Topology

-- Define the strategy set for Player 1 (batter)
inductive BatterPitcher_P1 : Type
  | F -- Fastball
  | C -- Curveball
  deriving DecidableEq, Fintype, Repr

-- Define the strategy set for Player 2 (pitcher)
inductive BatterPitcher_P2 : Type
  | F -- Fastball
  | C -- Curveball
  deriving DecidableEq, Fintype, Repr

-- Define player 1's utility function (batter)
def Claim_7_2_a_u1 : BatterPitcher_P1 → BatterPitcher_P2 → Int
  | .F, .F => -1
  | .F, .C =>  1
  | .C, .F =>  1
  | .C, .C => -1

-- Define player 2's utility function (pitcher)
-- u_2(s_1, s_2) = -u_1(s_1, s_2)