import Mathlib

variable {L : ℕ}

def HomogDegOne (u : (Fin L → ℝ) → ℝ) : Prop :=
  ∀ (α : ℝ), 0 < α → ∀ (x : Fin L → ℝ), u (α • x) = α * u x