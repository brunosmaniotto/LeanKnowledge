import Mathlib

open Relation

variable {α : Type*}

/-- A relation is non-reflexive if it is neither reflexive nor irreflexive. -/
def Nonreflexive (r : α → α → Prop) : Prop :=
  ¬Reflexive r ∧ ¬Irreflexive r