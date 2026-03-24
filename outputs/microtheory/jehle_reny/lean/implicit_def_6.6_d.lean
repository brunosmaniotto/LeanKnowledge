import Mathlib

variable {I X : Type*}

def IsIndividuallyDecisive (F : (I → X → X → Prop) → (X → X → Prop))
    (i : I) (x y : X) : Prop :=
  ∀ profile : I → X → X → Prop, profile i x y → F profile x y