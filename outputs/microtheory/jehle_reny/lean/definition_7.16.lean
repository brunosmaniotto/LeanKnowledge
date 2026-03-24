import Mathlib

/-- A node `x` defines a subgame of an extensive form game if:
    (1) The information set of `x` is the singleton `{x}`, and
    (2) For every decision node `y` that follows `x`, every node `z` in the
        information set containing `y` also follows `x`. -/
def DefinesSubgame {Node : Type*} [DecidableEq Node]
    (follows : Node → Node → Prop)
    (infoSet : Node → Finset Node)
    (x : Node) : Prop :=
  infoSet x = {x} ∧
    ∀ y : Node, follows x y →
      ∀ z ∈ infoSet y, follows x z