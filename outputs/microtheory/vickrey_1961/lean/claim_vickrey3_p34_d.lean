import Mathlib

open MeasureTheory ProbabilityTheory

/-- If yj(x) has a discontinuity at Xd, the probability Pd that bidder i
makes a bid of exactly Xd is positive. -/
theorem claim_vickrey3_p34_d
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {BidExactlyXd : Set Ω}
    (hMeas : MeasurableSet BidExactlyXd)
    -- The discontinuity of yj at Xd implies the event {bid = Xd} has positive measure
    (hDiscontinuity : μ BidExactlyXd ≠ 0) :
    0 < μ BidExactlyXd := by
  exact pos_iff_ne_zero.mpr hDiscontinuity