import Mathlib

variable {I X : Type*}

/-- Individual `i` is decisive for `x` over `y` under social preference function `F`
    if whenever `i` strictly prefers `x` to `y`, society strictly prefers `x` to `y`,
    regardless of all other individuals' preferences. -/
def IsDecisiveIndividual
    (F : (I → X → X → Prop) → X → X → Prop)
    (i : I) (x y : X) : Prop :=
  ∀ (profile : I → X → X → Prop), profile i x y → F profile x y