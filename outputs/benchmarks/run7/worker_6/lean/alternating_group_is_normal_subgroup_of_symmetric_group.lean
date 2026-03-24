import Mathlib

-- Proved sub-lemmas

-- Sub-lemma 1: The alternating group on a finite type α is a normal subgroup of the symmetric group on α.
lemma alternatingGroup_is_normal {α : Type*} [Fintype α] [DecidableEq α] : (alternatingGroup α).Normal := by
  -- This is a standard result in Mathlib, `alternatingGroup.normal`.
  exact alternatingGroup.normal

-- Sub-lemma 2: For a natural number n ≥ 2, the type Fin n (integers modulo n) is nontrivial.
-- A type is nontrivial if it has at least two distinct elements.