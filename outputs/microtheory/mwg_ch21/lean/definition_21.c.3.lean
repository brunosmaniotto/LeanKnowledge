import Mathlib

/-- A social welfare functional satisfies the Independence of Irrelevant Alternatives (IIA)
    condition if the social ranking of any pair {x, y} depends only on individual rankings
    of that same pair. -/
def PairwiseIndependence {X : Type*} {I : Type*}
    (F : (I → X → X → Prop) → (X → X → Prop)) : Prop :=
  ∀ (R R' : I → X → X → Prop) (x y : X),
    (∀ i, R i x y ↔ R' i x y) →
    (∀ i, R i y x ↔ R' i y x) →
    (F R x y ↔ F R' x y) ∧ (F R y x ↔ F R' y x)