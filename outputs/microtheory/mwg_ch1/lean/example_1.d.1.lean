import Mathlib

-- Model the three-element set
inductive X where
  | x | y | z
  deriving DecidableEq, Fintype

open X

-- Define the choice function on the three relevant budget sets
-- We represent budget sets and choices as Finsets
def budget1 : Finset X := {x, y}