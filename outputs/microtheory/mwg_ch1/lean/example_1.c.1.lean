import Mathlib

-- Model X as a finite type with 3 elements
inductive X : Type
  | x | y | z
  deriving DecidableEq, Fintype

open X

-- Define the budget sets
def B1 : Finset X := {x, y}