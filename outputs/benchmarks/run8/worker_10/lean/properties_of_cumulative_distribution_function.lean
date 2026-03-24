import Mathlib

open MeasureTheory ProbabilityTheory Filter

variable {Ω : Type _} [MeasurableSpace Ω] (Pr : Measure Ω) [IsProbabilityMeasure Pr] 
  (X : Ω → ℝ) (hX : Measurable X)

/-- The push-forward measure is a probability measure. -/
instance : IsProbabilityMeasure (Pr.map X) := by
  constructor
  rw [Measure.map_apply hX MeasurableSet.univ, Set.preimage_univ]
  exact measure_univ

/-- Cumulative distribution function of random variable X. -/
noncomputable def cdfX : ℝ → ℝ := ProbabilityTheory.cdf (Pr.map X)

theorem cdfX_nonneg (x : ℝ) : 0 ≤ cdfX Pr X x :=
  cdf_nonneg _ x