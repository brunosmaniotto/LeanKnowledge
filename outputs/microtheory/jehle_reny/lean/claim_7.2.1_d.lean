import Mathlib

open Function
open Topology

-- PlayerID type for identifying Player 1 and Player 2
inductive PlayerID : Type
  | P1 : PlayerID
  | P2 : PlayerID
deriving DecidableEq

-- Strategies for Player 1
inductive P1Strategy : Type
  | U : P1Strategy
  | D : P1Strategy
deriving DecidableEq, Fintype, Inhabited

-- Strategies for Player 2
inductive P2Strategy : Type
  | L : P2Strategy
  | R : P2Strategy
deriving DecidableEq, Fintype, Inhabited

-- Mapping PlayerID to their respective strategy types
def PlayerStrategyMap (p : PlayerID) : Type :=
  match p with
  | PlayerID.P1 => P1Strategy
  | PlayerID.P2 => P2Strategy

-- Payoff function for Player 2, given Player 1's and Player 2's strategies