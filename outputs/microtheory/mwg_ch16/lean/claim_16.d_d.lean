import Mathlib

variable {X : Type*} (price : X → ℝ) (weakPref strictPref : X → X → Prop)

def condII' (price : X → ℝ) (strictPref : X → X → Prop) (xstar : X) : Prop :=
  ∀ x, strictPref x xstar → price x ≥ price xstar