import Mathlib
open Topology

noncomputable section

-- We model the economic environment with functions representing the benefits and costs
-- associated with an externality-producing activity, measured by a real number `s`.

-- `benefit s` represents the producer's profit or utility from activity level `s`.
variable (benefit : ℝ → ℝ)

-- `cost s` represents the damage or disutility to a second party from the same activity level `s`.
variable (cost : ℝ → ℝ)

-- Social welfare is the sum of all parties' utilities.
def social_welfare (s : ℝ) : ℝ := benefit s - cost s

-- An activity level `s_opt` is socially optimal if it's a critical point of the welfare function.
-- For an interior maximum, this first-order condition (FOC) is necessary.