import Mathlib

/-- A rational preference relation `pref` (where `pref x y` means x ≿ y) is single-peaked
    with respect to a linear order `le` on `X` if there exists a peak `x*` such that
    preferences increase approaching the peak from either side. -/
def IsSinglePeaked {X : Type*} (pref : X → X → Prop) (le : X → X → Prop) : Prop :=
  ∃ xStar : X, (∀ z y : X, le xStar z → le z y → pref z y ∧ ¬pref y z) ∧
              (∀ y z : X, le y z → le z xStar → pref z y ∧ ¬pref y z)