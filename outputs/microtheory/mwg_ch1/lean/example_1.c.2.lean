import Mathlib

-- Three alternatives
inductive Alt : Type
  | x | y | z
  deriving DecidableEq, Fintype

open Alt Finset

-- A choice structure: a collection of budget sets and a choice function
-- We work with Finset Alt for decidability

-- Budget sets from Example 1.C.1
def B1 : Finset Alt := {x, y}