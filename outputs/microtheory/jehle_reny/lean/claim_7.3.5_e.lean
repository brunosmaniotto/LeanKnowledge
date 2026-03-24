import Mathlib

/-!
This file formalizes `Claim_7.3.5_e`: In a game of perfect information, every node defines a subgame.
-/

-- Definition of GameTree and PerfectInformation from the prompt
structure GameTree where
  Node : Type
  [decEq : DecidableEq Node]
  [fin : Fintype Node]
  infoSet : Node → Finset Node
  successors : Node → Finset Node

attribute [instance] GameTree.decEq GameTree.fin

def PerfectInformation (G : GameTree) : Prop :=
  ∀ v, G.infoSet v = {v}

-- Define "y follows x" as the transitive closure of the `successors` relation.
-- We use `Relation.TransGen` for this, meaning y is a descendant of x.