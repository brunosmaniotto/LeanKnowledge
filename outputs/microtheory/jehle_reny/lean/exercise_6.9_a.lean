import Mathlib

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

-- Define individual strict preferences
def individual_pref (person : Person) (a b : X) : Prop :=
  match person, a, b with
  | p1, x, y => true
  | p1, y, z => true
  | p1, x, z => true  -- Derived from p1 prefers x to y and y to z
  | p2, y, z => true
  | p2, z, x => true
  | p2, y, x => true  -- Derived from p2 prefers y to z and z to x
  | p3, z, x => true
  | p3, x, y => true
  | p3, z, y => true  -- Derived from p3 prefers z to x and x to y
  | _, _, _ => false

-- Helper to count preferences