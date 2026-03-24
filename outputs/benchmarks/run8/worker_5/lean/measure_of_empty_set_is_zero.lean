import Mathlib

open MeasureTheory

theorem measure_of_empty_set_is_zero {X : Type*} [MeasurableSpace X] (μ : Measure X) : μ ∅ = 0 :=
  measure_empty