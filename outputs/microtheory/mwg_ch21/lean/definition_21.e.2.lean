import Mathlib

/-- A social choice function `f` is weakly Paretian if no alternative that is strictly dominated
    by another alternative for every individual can be chosen. That is, if every individual
    strictly prefers `x` over `y`, then `f` does not choose `y`. -/
def IsWeaklyParetian
    {I : Type*} {X : Type*} {A : Type*}
    (pref : A → I → X → X → Prop)
    (f : A → X) : Prop :=
  ∀ (a : A) (x y : X),
    (∀ i : I, pref a i x y) →
    f a ≠ y