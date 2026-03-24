import Mathlib

open scoped Classical -- Needed for decidability

-- Model the three-element set of social states
inductive X : Type
  | x | y | z
  deriving DecidableEq, Fintype

open X

-- Model the three individuals
inductive Person : Type
  | p1 | p2 | p3
  deriving DecidableEq, Fintype

open Person

-- Helper to determine if a person strictly prefers a to b
def prefers (R : Person → X → X → Prop) (i : Person) (a b : X) : Prop := R i a b

-- Count how many individuals prefer alternative 'a' over 'b' in a given profile R