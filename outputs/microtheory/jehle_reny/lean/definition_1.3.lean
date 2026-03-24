import Mathlib

/-- Definition 1.3 (Jehle & Reny): The indifference relation induced by a preference
    relation ≿. We have x¹ ∼ x² if and only if x¹ ≿ x² and x² ≿ x¹. -/
def Indifferent {X : Type*} (pref : X → X → Prop) (x y : X) : Prop :=
  pref x y ∧ pref y x