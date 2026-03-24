import Mathlib

open MeasureTheory

theorem expectation_of_function_of_discrete {Ω β : Type*} [MeasurableSpace Ω] [Countable β] [MeasurableSpace β]
    [MeasurableSingletonClass β] (μ : Measure Ω) [IsProbabilityMeasure μ] (X : Ω → β) (g : β → ℝ)
    (hX : Measurable X) (hg : Integrable g (μ.map X)) :
    ∫ ω, g (X ω) ∂μ = ∑' x : β, g x * ENNReal.toReal ((μ.map X) {x}) := by
  sorry