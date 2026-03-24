import Mathlib

/-- A choice structure (ℬ, C(·)) on a type X consists of:
  - A family ℬ of nonempty subsets of X (the budget sets)
  - A choice rule C that assigns to each budget set B ∈ ℬ a nonempty subset C(B) ⊆ B -/
structure ChoiceStructure (X : Type*) where
  /-- The family of budget sets -/
  budgetSets : Set (Set X)
  /-- Every budget set is nonempty -/
  budgetSets_nonempty : ∀ B ∈ budgetSets, B.Nonempty
  /-- The choice rule: assigns a subset of X to each budget set -/
  choiceRule : Set X → Set X
  /-- The chosen set is nonempty for every budget set -/
  choiceRule_nonempty : ∀ B ∈ budgetSets, (choiceRule B).Nonempty
  /-- The chosen set is a subset of the budget set -/
  choiceRule_subset : ∀ B ∈ budgetSets, choiceRule B ⊆ B