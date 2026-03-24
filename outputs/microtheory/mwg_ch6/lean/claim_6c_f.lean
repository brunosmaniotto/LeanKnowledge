import Mathlib

open MeasureTheory
open Topology

/-- For a risk averter (concave utility), the certainty equivalent is at most the expected value. -/
theorem certainty_equiv_le_expected_value
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (u : ℝ → ℝ)
    (hu_mono : StrictMono u)
    (c : ℝ)
    (hc_def : u c = ∫ ω, u (X ω) ∂μ)
    -- Jensen's inequality for concave u: 𝔼[u(X)] ≤ u(𝔼[X])
    (h_jensen : ∫ ω, u (X ω) ∂μ ≤ u (∫ ω, X ω ∂μ)) :
    c ≤ ∫ ω, X ω ∂μ := by
  by_contra h
  push_neg at h
  -- h : ∫ X < c
  -- From strict monotonicity: u(∫ X) < u(c)
  have h2 : u (∫ ω, X ω ∂μ) < u c := hu_mono h
  -- But hc_def says u(c) = ∫ u(X), and h_jensen says ∫ u(X) ≤ u(∫ X)
  -- So u(c) = ∫ u(X) ≤ u(∫ X) < u(c), contradiction
  linarith