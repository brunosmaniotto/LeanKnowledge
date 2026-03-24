import Mathlib

open MeasureTheory ProbabilityTheory

/-- If bidder 2 determines his bid by a random drawing from a distribution,
    y₂(x) can be defined as the probability that his bid is less than x,
    i.e., the CDF of the bid distribution. -/
theorem claim_vickrey3_p33_i
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (bid : Ω → ℝ) (hbid : Measurable bid) :
    ∃ y₂ : ℝ → ENNReal, y₂ = fun x => μ {ω | bid ω < x} := by
  exact ⟨fun x => μ {ω | bid ω < x}, rfl⟩