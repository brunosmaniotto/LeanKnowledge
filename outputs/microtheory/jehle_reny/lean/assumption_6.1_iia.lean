import Mathlib

/-- Independence of Irrelevant Alternatives (IIA): the social ranking of any pair {x, y}
    depends only on individuals' rankings of that pair. -/
def Assumption_6_1_IIA {X : Type*} {I : Type*}
    (f : (I → X → X → Prop) → (X → X → Prop)) : Prop :=
  ∀ (R R' : I → X → X → Prop) (x y : X),
    (∀ i, R i x y ↔ R' i x y) →
    (∀ i, R i y x ↔ R' i y x) →
    (f R x y ↔ f R' x y)