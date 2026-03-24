import Mathlib

def SocialWelfareFunctional (X : Type*) (ι : Type*) :=
  (ι → X → ℝ) → X → X → Prop