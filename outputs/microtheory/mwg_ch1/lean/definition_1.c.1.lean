import Mathlib

/-- A choice structure on a type `X` of alternatives. -/
structure ChoiceStructure (X : Type*) where
  /-- The collection ℬ of budget sets. -/
  budgets : Set (Set X)
  /-- The choice rule C(·), mapping each budget set to its chosen subset. -/
  choice : Set X → Set X

/-- Definition 1.C.1 (MWG). A choice structure satisfies the **weak axiom of
revealed preference** if: whenever `x` is chosen from some budget set `B`
containing both `x` and `y`, then `x` must also be chosen from any other
budget set `B'` that contains both `x` and `y` and from which `y` is chosen. -/
def WeakAxiomOfRevealedPreference {X : Type*} (cs : ChoiceStructure X) : Prop :=
  ∀ B ∈ cs.budgets, ∀ B' ∈ cs.budgets,
    ∀ x y : X,
      x ∈ B → y ∈ B → x ∈ cs.choice B →
      x ∈ B' → y ∈ B' → y ∈ cs.choice B' →
      x ∈ cs.choice B'