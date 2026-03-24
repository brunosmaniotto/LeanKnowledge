import Mathlib

/-- The collection of all rational preference relations on `X` that are single peaked
with respect to a given linear order `≥` on `X`. (MWG Definition 21.D.4) -/
def singlePeakedPreferences {X : Type*} [Fintype X]
    (le : LinearOrder X)
    (R : Set (X → X → Prop))
    (isRational : (X → X → Prop) → Prop)
    (isSinglePeaked : LinearOrder X → (X → X → Prop) → Prop) :
    Set (X → X → Prop) :=
  {r ∈ R | isRational r ∧ isSinglePeaked le r}