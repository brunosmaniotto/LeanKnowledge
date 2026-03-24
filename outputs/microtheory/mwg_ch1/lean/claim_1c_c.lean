import Mathlib

-- Choice structure: a collection of budget sets and a choice rule
structure ChoiceStructure (X : Type*) where
  BudgetSets : Set (Set X)
  C : Set X → Set X
  choice_subset : ∀ B ∈ BudgetSets, C B ⊆ B
  choice_nonempty : ∀ B ∈ BudgetSets, (C B).Nonempty

variable {X : Type*} (cs : ChoiceStructure X)

-- x is revealed at least as good as y: x is chosen from some B containing y
def RevealedAtLeastAsGood (x y : X) : Prop :=
  ∃ B ∈ cs.BudgetSets, y ∈ B ∧ x ∈ cs.C B

-- x is revealed strictly preferred to y: x is chosen from some B containing y, and y is not chosen