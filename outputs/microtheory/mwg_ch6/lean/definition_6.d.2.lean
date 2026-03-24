import Mathlib

open MeasureTheory

/-- F second-order stochastically dominates G (SOSD) if for every nondecreasing
    concave function u : ℝ → ℝ, the expected value of u under F is at least
    that under G. Both F and G are given as finite measures on ℝ. -/
noncomputable def SecondOrderStochDom (F G : Measure ℝ) : Prop :=
  ∀ u : ℝ → ℝ, Monotone u → ConcaveOn ℝ Set.univ u →
    ∫ x, u x ∂F ≥ ∫ x, u x ∂G