import Mathlib

open Filter Topology

/-- If the discount factor δ is close to 1 (agents are patient), then the change in the
marginal utility of wealth from a price change is small. -/
theorem Claim_20I_b
    (DeltaM : ℝ → ℝ)  -- change in marginal utility of wealth as a function of delta
    (DeltaP : ℝ)       -- price change in period 0
    (hDeltaP : DeltaP ≠ 0)
    (hcont : Continuous DeltaM)
    (hDeltaM_at_one : DeltaM 1 = 0)
    : Tendsto DeltaM (nhds 1) (nhds 0) := by
  rw [← hDeltaM_at_one]
  exact hcont.continuousAt.tendsto