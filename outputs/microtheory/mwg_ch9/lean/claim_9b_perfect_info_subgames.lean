import Mathlib

structure GameTree where
  Node : Type
  [decEq : DecidableEq Node]
  [fin : Fintype Node]
  infoSet : Node → Finset Node
  successors : Node → Finset Node

attribute [instance] GameTree.decEq GameTree.fin

def PerfectInformation (G : GameTree) : Prop :=
  ∀ v, G.infoSet v = {v}