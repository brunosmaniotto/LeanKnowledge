import Mathlib

open MeasureTheory

theorem probability_measure_subadditive {Ω : Type*} [MeasurableSpace Ω] 
    (μ : ProbabilityMeasure Ω) {ι : Type*} [Countable ι] (s : ι → Set Ω) :
    (μ : Measure Ω) (⋃ i, s i) ≤ ∑' i, (μ : Measure Ω) (s i) :=
  measure_iUnion_le s