import Mathlib

/-- A singleton information set is an information set containing a single decision node. -/
def isSingletonInfoSet {Node : Type*} (infoSet : Finset Node) : Prop :=
  infoSet.card = 1