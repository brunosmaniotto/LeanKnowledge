import Mathlib

/-- Property (vi): Irreversibility. A production set Y is irreversible if for every
    y ∈ Y with y ≠ 0, we have −y ∉ Y. -/
def ProductionSet.IsIrreversible {ι : Type*} (Y : Set (ι → ℝ)) : Prop :=
  ∀ y ∈ Y, y ≠ 0 → -y ∉ Y