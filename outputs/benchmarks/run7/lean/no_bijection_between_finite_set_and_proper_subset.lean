import Mathlib

-- This sub-lemma establishes that a proper subset of a finite set has a strictly smaller cardinality.
-- We use `Set.ncard`, the cardinality of a set as a natural number, which is suitable for finite sets.
lemma card_of_proper_subset_is_strictly_less {α : Type*} {S T : Set α} (hS : S.Finite) (hT_ssub_S : T ⊂ S) : Set.ncard T < Set.ncard S := by
  -- Mathlib has a lemma that directly proves this from the proper subset relation and finiteness of the superset.
  exact Set.ncard_lt_ncard hT_ssub_S hS

-- This sub-lemma states that if two finite sets are equivalent (in bijection), they have the same cardinality.