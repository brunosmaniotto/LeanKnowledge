import Mathlib
open Finset
open BigOperators

-- Define the alternatives
inductive Project
  | S
  | B

open Project

-- Type space for each individual: {1,2,...,9}
def T : Finset ℕ := Finset.Icc 1 9

-- Valuation function