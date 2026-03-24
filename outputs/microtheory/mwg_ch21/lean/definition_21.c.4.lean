import Mathlib

variable {I X : Type*}

def IsDecisiveForPair (F : (I → X → X → Prop) → (X → X → Prop))
    (S : Set I) (x y : X) : Prop :=
  ∀ (profile : I → X → X → Prop),
    (∀ i ∈ S, profile i x y) →
    (∀ i, i ∉ S → profile i y x) →
    F profile x y