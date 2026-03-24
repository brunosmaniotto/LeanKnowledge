import Mathlib

/-- Property (v): Free disposal. If y ∈ Y and y' ≤ y, then y' ∈ Y.
    Equivalently, Y − ℝ^L_+ ⊂ Y. -/
def FreeDisposal {L : Type*} [Fintype L] (Y : Set (L → ℝ)) : Prop :=
  ∀ y ∈ Y, ∀ y' : L → ℝ, y' ≤ y → y' ∈ Y