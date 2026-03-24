import Mathlib

axiom Consumer : Type
axiom Alloc : Type
axiom FeasibleSet : Set Alloc
axiom coalitionBlocks : Finset Consumer → Alloc → Prop
axiom Consumer.fintype : Fintype Consumer
attribute [instance] Consumer.fintype

def isUnblockedByAll (x : Alloc) : Prop :=
  x ∈ FeasibleSet ∧ ∀ S : Finset Consumer, ¬coalitionBlocks S x