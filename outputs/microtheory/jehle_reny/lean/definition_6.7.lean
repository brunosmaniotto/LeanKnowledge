import Mathlib
open Topology

/-- A social choice function is **monotonic** if the social choice `x` is preserved
whenever every individual's new preferences strictly improve `x` over any distinct
alternative that `x` was originally at least as good as. -/
def IsMonotonicSCF {I X : Type*} (c : (I → X → X → Prop) → X) : Prop :=
  ∀ (R R' : I → X → X → Prop) (x : X),
    c R = x →
    (∀ (i : I) (y : X), y ≠ x → R i x y → (R' i x y ∧ ¬ R' i y x)) →
    c R' = x