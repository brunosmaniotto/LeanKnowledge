import Mathlib

open MeasureTheory

theorem countable_set_has_measure_zero {S : Set ℝ} (hS : S.Countable) : volume S = 0 :=
  hS.measure_zero volume