import Mathlib

open Set Submodule FiniteDimensional

variable {K : Type _} [DivisionRing K] {E : Type _} [AddCommGroup E] [Module K E]

def IsBasis (B : Set E) : Prop :=
  LinearIndependent K ((↑) : B → E) ∧ span K B = ⊤