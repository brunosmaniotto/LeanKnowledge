import Mathlib

theorem continuous_on_closed_interval_is_uniformly_continuous {a b : ℝ} (f : Set.Icc a b → ℝ)
    (hcont : Continuous f) : UniformContinuous f := by
  have hcomp_set : IsCompact (Set.Icc a b : Set ℝ) := isCompact_Icc
  have : CompactSpace (Set.Icc a b) := isCompact_iff_compactSpace.mp hcomp_set
  exact CompactSpace.uniformContinuous_of_continuous hcont