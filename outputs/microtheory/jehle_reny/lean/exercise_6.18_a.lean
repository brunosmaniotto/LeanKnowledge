import Mathlib
open Topology

-- Type of alternatives
variable {X : Type*} [DecidableEq X]
-- Type of individuals
variable {I : Type*} [Inhabited I] [Fintype I]

-- A preference relation is a strict total order
-- R i a b means individual i strictly prefers a to b.
variable (R : I → X → X → Prop)
variable (R_tilde : I → X → X → Prop) -- R_tilde is the modified profile for individual i

-- Social Choice Function
variable (c : (I → X → X → Prop) → X)

-- Definition of Monotonic Social Choice Function from the codebase
def IsMonotonicSCF_Full :=
  ∀ (R_profile R'_profile : I → X → X → Prop) (x_choice : X),
    c R_profile = x_choice →
    (∀ (i : I) (y_alt : X), y_alt ≠ x_choice → R_profile i x_choice y_alt → (R'_profile i x_choice y_alt ∧ ¬ R'_profile i y_alt x_choice)) →
    c R'_profile = x_choice

-- Helper definition for a preference relation being a strict ranking
-- (Irreflexive, Transitive, Asymmetric, and Trichotomous - a strict total order)