import Mathlib

/-- An N × N matrix has the gross substitute sign pattern if every nondiagonal entry is positive. -/
def MWG.HasGrossSubstituteSignPattern {N : Type*} [Fintype N] [DecidableEq N]
    (M : Matrix N N ℝ) : Prop :=
  ∀ i j, i ≠ j → 0 < M i j