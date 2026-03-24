import Mathlib

/-- A node x is penultimate in a finite extensive form game if all nodes
    immediately following x are terminal (end) nodes. -/
def IsPenultimate {Node : Type*} (successors : Node → Finset Node)
    (isTerminal : Node → Prop) [DecidablePred isTerminal] (x : Node) : Prop :=
  (successors x).Nonempty ∧ ∀ y ∈ successors x, isTerminal y