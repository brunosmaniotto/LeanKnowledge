import Mathlib

namespace CoordGame7B

inductive Move where
  | A
  | B
  deriving DecidableEq

def payoff (mine other : Move) : ℕ :=
  if mine = other then 1 else 0