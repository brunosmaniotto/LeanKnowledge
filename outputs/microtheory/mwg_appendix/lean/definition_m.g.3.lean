import Mathlib

def MWG.IsExtremePoint {N : ℕ} (B : Set (Fin N → ℝ)) (x : Fin N → ℝ) : Prop :=
  x ∈ B ∧ ∀ y ∈ B, ∀ z ∈ B, ∀ α : ℝ, 0 < α → α < 1 →
    x = α • y + (1 - α) • z → y = x ∧ z = x