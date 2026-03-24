import Mathlib

def MoreRiskAverse (u₁ u₂ : ℝ → ℝ) : Prop :=
  ∃ g : ℝ → ℝ, ConcaveOn ℝ Set.univ g ∧ ∀ x, u₂ x = g (u₁ x)