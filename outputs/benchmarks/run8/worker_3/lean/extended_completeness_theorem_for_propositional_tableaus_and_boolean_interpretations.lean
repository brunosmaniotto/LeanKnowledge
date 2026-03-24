import Mathlib

noncomputable section

variable (α : Type*)

-- Propositional formulas over variables of type α
inductive PropForm (α : Type*)
  | var : α → PropForm α
  | not : PropForm α → PropForm α
  | and : PropForm α → PropForm α → PropForm α
  | or : PropForm α → PropForm α → PropForm α
  | impl : PropForm α → PropForm α → PropForm α

-- Boolean valuations
def PropValuation (α : Type*) := α → Bool

-- Satisfaction relation