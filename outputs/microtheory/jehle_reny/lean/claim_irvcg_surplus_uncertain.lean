import Mathlib

open BigOperators

/-- The IR‑VCG mechanism may or may not run an expected surplus.
    Specifically, for any nonnegative expected surplus `surplus_VCG` of the VCG mechanism,
    there exist total participation subsidies that make the IR‑VCG expected surplus positive,
    and there exist total participation subsidies that make it negative. -/
theorem Claim_IRVCG_surplus_uncertain (surplus_VCG : ℝ) (h_nonneg : surplus_VCG ≥ 0) :
    ∃ (subsidies : ℝ), (surplus_VCG - subsidies > 0) ∧ ∃ (subsidies : ℝ), (surplus_VCG - subsidies < 0) := by
  use surplus_VCG - 1
  constructor
  · linarith
  · use surplus_VCG + 1
    linarith