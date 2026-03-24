import Mathlib

theorem distance_from_set_properties (x : ℝ) (S : Set ℝ) :
    0 ≤ Metric.infDist x S ∧ (x ∈ S → Metric.infDist x S = 0) := by
  exact ⟨Metric.infDist_nonneg, fun h => Metric.infDist_zero_of_mem h⟩