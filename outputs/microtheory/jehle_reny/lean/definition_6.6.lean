import Mathlib

/-- Definition 6.6: A social choice function `c` is Pareto efficient if `c profile = x`
    whenever every individual strictly prefers `x` to every other alternative. -/
def IsParetoEfficient {I X : Type*}
    (c : (I → X → X → Prop) → X) : Prop :=
  ∀ (profile : I → X → X → Prop) (x : X),
    (∀ i : I, ∀ y : X, y ≠ x → (profile i x y ∧ ¬profile i y x)) →
    c profile = x