import Mathlib

open Set
open Topology

-- Define player actions for the Batter
inductive BatterAction : Type
  | Fastball
  | Curveball
  deriving DecidableEq, Fintype, Repr

-- Define player actions for the Pitcher
inductive PitcherAction : Type
  | Fastball
  | Curveball
  deriving DecidableEq, Fintype, Repr

-- Define the Batter's payoff function for each strategy profile
def batter_payoff (b : BatterAction) (p : PitcherAction) : Int :=
  match b, p with
  | .Fastball, .Fastball => 1
  | .Fastball, .Curveball => -1
  | .Curveball, .Fastball => -1
  | .Curveball, .Curveball => 1

-- Define the Pitcher's payoff function for each strategy profile
-- (Assuming a zero-sum game where Pitcher's payoff is the negative of Batter's)