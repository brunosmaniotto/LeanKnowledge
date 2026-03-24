import Mathlib

open MeasureTheory

/-- In a measure space, the measure is monotone: if E ⊆ F, then μ E ≤ μ F. -/
theorem measure_is_monotone {X : Type*} [MeasurableSpace X] (μ : Measure X) {E F : Set X} 
    (h : E ⊆ F) : μ E ≤ μ F :=
  μ.mono h