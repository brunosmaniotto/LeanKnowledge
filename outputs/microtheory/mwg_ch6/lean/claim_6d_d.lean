import Mathlib

open MeasureTheory

noncomputable section

def SOSD (F G : Measure ℝ) : Prop :=
  ∀ u : ℝ → ℝ, ConcaveOn ℝ Set.univ u → ∫ x, u x ∂G ≤ ∫ x, u x ∂F