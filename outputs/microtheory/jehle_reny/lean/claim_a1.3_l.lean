import Mathlib

theorem claim_A1_3_l (a b : ℝ) : Bornology.IsBounded (Set.Ioo a b) := by
  exact Metric.isBounded_Ioo a b