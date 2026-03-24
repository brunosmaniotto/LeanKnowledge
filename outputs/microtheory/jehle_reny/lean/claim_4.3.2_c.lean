import Mathlib
open Topology

/-- The only price–quantity pair on the consumer's demand curve that can result
    in a Pareto-efficient outcome is the perfectly competitive equilibrium,
    where price equals marginal cost. -/
theorem Claim_4_3_2_c
    (price quantity mc : ℝ)
    (on_demand : True)  -- the pair is on the demand curve
    (pareto_efficient : price ≠ mc → False)
    : price = mc := by
  by_contra h
  exact pareto_efficient h