import Mathlib
open Finset
open Fintype

-- Define the set of alternatives as an inductive type with three elements
inductive X : Type
  | x | y | z
  deriving DecidableEq, Fintype, Inhabited

open X
open Topology

-- A type for individuals/voters
variable {I : Type*} [Fintype I] [DecidableEq I] [Inhabited I]

-- An individual's strict preference relation
variable (P : I → X → X → Prop)
-- Add Decidable instance for P i a b to allow Finset.filter to work
variable [∀ i a b, Decidable (P i a b)]

-- Assume individual preferences are irreflexive
variable (P_irreflexive : ∀ i a, ¬P i a a)
-- Assume individual preferences are asymmetric
variable (P_asymmetric : ∀ i a b, P i a b → ¬P i b a)
-- Assume individual preferences are complete for distinct alternatives
variable (P_complete : ∀ i a b, a ≠ b → (P i a b ∨ P i b a))

-- Number of individuals who strictly prefer a to b
def num_prefer (a b : X) : ℕ :=
  (univ.filter (fun i : I => P i a b)).card

-- Pairwise majority voting relation with tie-breaking x > y > z