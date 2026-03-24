import Mathlib
open Topology

variable {I X : Type*}

/-- A social choice function `c` is strongly monotonic if whenever `c(R) = x` and
    every individual's weak preference for `x` over any `y` is preserved
    (i.e., `x Rᵢ y → x R̃ᵢ y` for all `i` and `y`), then `c(R̃) = x`. -/
def IsStronglyMonotonic (c : (I → X → X → Prop) → X) : Prop :=
  ∀ (R R' : I → X → X → Prop) (x : X),
    c R = x →
    (∀ i : I, ∀ y : X, R i x y → R' i x y) →
    c R' = x