import Mathlib

/-- The Strong Axiom of Revealed Preference (SARP).
    Given a revealed preference relation R on bundles, SARP holds when there
    is no sequence of distinct bundles x₀, x₁, …, xₖ with
    x₀ R x₁ R ⋯ R xₖ R x₀. This is equivalent to the transitive closure
    of R being irreflexive. -/
def SARP {X : Type*} (R : X → X → Prop) : Prop :=
  ∀ x : X, ¬Relation.ReflTransGen R x x