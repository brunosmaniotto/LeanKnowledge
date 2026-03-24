import Mathlib
open Topology

/-- Strict welfarism: a social welfare functional F satisfies the conjunction of
    Universality (U), Weak Pareto (WP), Independence of Irrelevant Alternatives (IIA),
    and Pareto Indifference (PI). Distinguished from Sen's welfarism (U + IIA + PI)
    by the addition of WP. -/
structure StrictWelfarism {I : Type*} {X : Type*}
    (F : (I → X → X → Prop) → (X → X → Prop)) : Prop where
  /-- Universality: F is defined for every logically possible preference profile.
      In type theory this is automatic since F is total; retained for fidelity
      to the four-condition definition. -/
  universality : True
  /-- Weak Pareto: unanimous strict preference implies social strict preference -/
  weakPareto : ∀ (R : I → X → X → Prop) (x y : X),
    (∀ i, R i x y ∧ ¬ R i y x) → F R x y ∧ ¬ F R y x
  /-- Independence of Irrelevant Alternatives: the social ranking of {x, y}
      depends only on individual rankings of {x, y} -/
  iia : ∀ (R R' : I → X → X → Prop) (x y : X),
    (∀ i, (R i x y ↔ R' i x y) ∧ (R i y x ↔ R' i y x)) →
    (F R x y ↔ F R' x y)
  /-- Pareto Indifference: unanimous indifference implies social indifference -/
  paretoIndifference : ∀ (R : I → X → X → Prop) (x y : X),
    (∀ i, R i x y ∧ R i y x) → F R x y ∧ F R y x