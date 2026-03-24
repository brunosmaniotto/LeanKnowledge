import Mathlib
open MeasureTheory ProbabilityTheory Filter

theorem Claim_III_H {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    [IsProbabilityMeasure μ] (G : Ω → ℝ) (hG_measurable : AEStronglyMeasurable G μ)
    (h_non_negative_almost_everywhere : ∀ᵐ ω ∂μ, 0 ≤ G ω) :
    μ {ω | G ω < 0} = 0 := by
  -- The definition of "almost everywhere" (`MeasureTheory.ae_iff`) states that
  -- `(∀ᵐ x ∂μ, P x)` is equivalent to `μ {x | ¬P x} = 0`.
  -- We apply this equivalence to our hypothesis `h_non_negative_almost_everywhere`.
  have h_set_measure_zero : μ {ω | ¬(0 ≤ G ω)} = 0 := by
    rw [MeasureTheory.ae_iff] at h_non_negative_almost_everywhere
    exact h_non_negative_almost_everywhere

  -- Now we need to show that the set `{ω | G ω < 0}` is the same as `{ω | ¬(0 ≤ G ω)}`.
  -- This is a basic property of inequalities for real numbers.
  suffices {ω | G ω < 0} = {ω | ¬(0 ≤ G ω)} from by
    -- If the sets are equal, their measures are equal.
    -- We can then substitute this equality into our goal and use `h_set_measure_zero`.
    rw [this]
    exact h_set_measure_zero

  -- Proof of set equality:
  ext ω
  -- The goal is `G ω < 0 ↔ ¬(0 ≤ G ω)`, which is true by definition of `<`.
  simp only [not_le]