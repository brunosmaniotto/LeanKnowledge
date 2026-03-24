import Mathlib

/-- Property (iii): No free lunch. A production set Y satisfies this property
if whenever y ∈ Y and y ≥ 0 (componentwise), then y = 0.
Equivalently, Y ∩ ℝ^L₊ ⊆ {0}. -/
def NoFreeLunch {L : ℕ} (Y : Set (Fin L → ℝ)) : Prop :=
  ∀ y ∈ Y, 0 ≤ y → y = 0