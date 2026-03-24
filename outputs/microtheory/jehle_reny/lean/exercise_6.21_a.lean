import Mathlib
open Finset BigOperators Nat

-- Define the social states
inductive State : Type
  | x : State
  | y : State
  | z : State
  deriving DecidableEq, Fintype, Inhabited

-- Define the individuals
inductive Individual : Type
  | i1 : Individual
  | i2 : Individual
  deriving DecidableEq, Fintype, Inhabited

open Individual State

-- Preference is a utility function mapping states to natural numbers.
-- Higher number means higher preference.
def Preference := State → ℕ

-- Helper function to find top-ranked elements for a given utility function.
-- This returns the set of states that maximize the utility function.