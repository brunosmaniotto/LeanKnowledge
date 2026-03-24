import Mathlib

-- Social choice framework
variable {I X : Type*} [Fintype I] [Fintype X]

-- Social preference relation (strict)
variable (F : (I → X → X → Prop) → X → X → Prop)

-- Decisiveness: S is decisive if whenever all i ∈ S strictly prefer x to y, society does too
def Decisive (F : (I → X → X → Prop) → X → X → Prop) (S : Finset I) : Prop :=
  ∀ (profile : I → X → X → Prop) (x y : X),
    (∀ i ∈ S, profile i x y) → F profile x y

-- Complete decisiveness for x over y: for any profile where S members prefer x to y,
-- regardless of others' preferences, x is socially preferred to y