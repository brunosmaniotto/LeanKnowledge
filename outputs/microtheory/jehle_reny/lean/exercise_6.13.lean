import Mathlib
open Topology

variable {I X : Type*} [Fintype I] [DecidableEq I] [Fintype X] [DecidableEq X]

-- Definition 6.6.d: IsIndividuallyDecisive (provided in prompt)
def IsIndividuallyDecisive (F : (I → X → X → Prop) → (X → X → Prop))
    (i : I) (x y : X) : Prop :=
  ∀ profile : I → X → X → Prop, profile i x y → F profile x y

-- Weak Pareto (WP)