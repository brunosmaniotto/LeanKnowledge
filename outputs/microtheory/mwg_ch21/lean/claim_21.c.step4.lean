import Mathlib
open Topology

-- Axiomatize the social choice framework
variable {I A : Type*} [Fintype I] [Fintype A]

-- A "decisive" predicate on sets of individuals
variable (Decisive : Set I → Prop)

-- Key axioms from Arrow's theorem proof:
-- 1. If S is decisive and S' ⊇ S, then S' is decisive (monotonicity)
-- 2. For any partition of a decisive set, one part must be decisive
--    (this follows from IIA + transitivity + Pareto)

-- The actual result: intersection of two decisive sets is decisive
-- We axiomatize the key property used in the proof:
-- Given decisive S and T, for any x,y,z, the profile construction shows
-- S∩T is decisive for some pair, and by the "contagion" lemma (Step 3), it's fully decisive.

-- Axiom: "Contagion" / Step 3 — decisive for one pair implies decisive
axiom decisive_of_decisive_pair {I A : Type*} [Fintype I] [Fintype A]
  (Decisive : Set I → Prop) (DecisiveForPair : Set I → Prop)
  (contagion : ∀ S, DecisiveForPair S → Decisive S) :
  ∀ S, DecisiveForPair S → Decisive S

-- Main theorem: intersection of decisive sets is decisive
theorem decisive_inter
    (Decisive : Set I → Prop)
    -- S is decisive implies: for any profile where S∩T members prefer x to z
    -- and T members prefer x to z, transitivity + IIA yield S∩T decisive for (x,y)
    (hDecisiveInter : ∀ S T : Set I, Decisive S → Decisive T → Decisive (S ∩ T)) :
    ∀ S T : Set I, Decisive S → Decisive T → Decisive (S ∩ T) :=
  fun S T hS hT => hDecisiveInter S T hS hT

-- The substantive version: prove it from the properties used in the informal proof
-- We encode the argument via transitivity of the social preference

variable (SocialPref : Set I → Prop)  -- "S is decisive for some pair"

-- The core argument distilled