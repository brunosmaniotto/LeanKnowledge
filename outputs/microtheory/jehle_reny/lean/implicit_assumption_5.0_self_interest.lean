import Mathlib
open Topology

/-- Each consumer's utility depends only on their own bundle (no consumption externalities).
    Given a utility function that could in principle depend on the entire allocation,
    this predicate asserts that consumer i's utility depends only on their own bundle x i. -/
def SelfInterested {I : Type*} {Bundle : Type*}
    (u : I → (I → Bundle) → ℝ) : Prop :=
  ∀ (i : I) (x y : I → Bundle), x i = y i → u i x = u i y