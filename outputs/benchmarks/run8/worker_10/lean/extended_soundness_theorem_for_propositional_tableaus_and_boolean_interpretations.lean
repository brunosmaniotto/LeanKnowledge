import Mathlib.Data.Set.Basic

variable {α : Type}

inductive PropForm (α : Type) where
  | var : α → PropForm α
  | neg : PropForm α → PropForm α
  | and : PropForm α → PropForm α → PropForm α
  | or : PropForm α → PropForm α → PropForm α
  | imp : PropForm α → PropForm α → PropForm α

def Valuation (α : Type) : Type := α → Bool