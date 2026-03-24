import Mathlib

variable {ι : Type u} {M : Type v} [MetricSpace M] {U : ι → Set M}

theorem Union_of_Open_Sets_of_Metric_Space_is_Open (h : ∀ i, IsOpen (U i)) : IsOpen (⋃ i, U i) :=
  isOpen_iUnion h