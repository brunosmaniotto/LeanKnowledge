import Mathlib

/-!
# Order of a Conjugate Subgroup

This file proves that a subgroup `H` and its conjugate `aHa⁻¹` have the same order.
The proof proceeds in three steps:
1.  Define the isomorphism `H ≃* aHa⁻¹`. This is provided by `MulEquiv.subgroupMap`.
2.  Prove that isomorphic finite groups have the same cardinality. This follows from the fact
    that a group isomorphism implies a bijection between the underlying types.
3.  Combine these facts to prove the main theorem.
-/

-- Sub-lemma 1: An isomorphism between a subgroup and its conjugate.
/-- A subgroup `H` is isomorphic to its conjugate `aHa⁻¹`.

The conjugate subgroup `aHa⁻¹` is expressed in Mathlib as
`H.map (MulAut.conj a).toMonoidHom`. The isomorphism is induced by the
conjugation automorphism `MulAut.conj a`. -/
def conjugate_subgroup_isomorphism {G : Type*} [Group G] (a : G) (H : Subgroup G) :
    H ≃* H.map (MulAut.conj a).toMonoidHom :=
  -- The function `MulEquiv.subgroupMap` provides exactly this isomorphism.
  -- It takes a `MulEquiv` (here, `MulAut.conj a`) and a `Subgroup` `H`
  -- and returns a `MulEquiv` between `H` and its image `H.map ...`.
  MulEquiv.subgroupMap (MulAut.conj a) H

-- Sub-lemma 2: Isomorphic finite groups have the same cardinality.
-- This lemma formalizes the idea behind the user's proposed `card_eq_of_mulEquiv`.