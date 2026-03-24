import Mathlib

open Set Metric

def MWG.IsLocalMaximizer {N : ℕ} (f : (Fin N → ℝ) → ℝ) (x_bar : Fin N → ℝ) : Prop :=
  ∃ ε > 0, ∀ x ∈ ball x_bar ε, f x_bar ≥ f x