import Mathlib

open Relation

variable {α : Type*} (R : Rel α α)

/-! 
  Mathlib already has `Rel.inv` for inverse relations.
  We'll use the existing definitions of reflexive, symmetric, etc.
  For properties not in Mathlib (antireflexive, non-reflexive, etc.),
  we define them locally.
-/

-- First, define the missing properties
def Antireflexive (r : Rel α α) : Prop := ∀ a, ¬ r a a