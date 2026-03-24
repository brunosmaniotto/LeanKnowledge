import Mathlib

theorem Metric_Induced_by_a_Pseudometric (X : Type*) [PseudoMetricSpace X] :
  Nonempty (MetricSpace (SeparationQuotient X)) :=
  ⟨inferInstance⟩