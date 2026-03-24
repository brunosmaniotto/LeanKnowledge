import Mathlib

-- Sub-lemma 1: A subgroup of a cyclic group is cyclic.
-- This is already an instance in Mathlib, but we state it as a lemma for clarity.
lemma subgroup_of_cyclic_is_cyclic {G : Type*} [Group G] [IsCyclic G] (H : Subgroup G) : IsCyclic H := by
  exact Subgroup.isCyclic H

-- Sub-lemma 2: A non-trivial subgroup of an infinite cyclic group is infinite.