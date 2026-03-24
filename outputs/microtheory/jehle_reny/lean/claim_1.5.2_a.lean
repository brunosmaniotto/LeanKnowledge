import Mathlib
open Topology

/-- Under the Hicksian decomposition, the total effect of a price change is always
    completely explained by the sum of the substitution effect and the income effect:
    TE = SE + IE. Since IE is defined as the residual (TE − SE), this holds by construction. -/
theorem Claim_1_5_2_a (TE SE IE : ℝ) (h : IE = TE - SE) : TE = SE + IE := by
  linarith