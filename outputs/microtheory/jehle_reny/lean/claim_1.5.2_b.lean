import Mathlib

/-- Claim 1.5.2(b): Slutsky decomposition of demand.
    The total effect on the Marshallian demand curve (x1 - x0) equals
    the substitution effect on the Hicksian demand curve (xs - x0)
    plus the income effect (x1 - xs).
    Points (p0, x0) and (p1, x1) lie on the Marshallian demand curve;
    points (p0, x0) and (p1, xs) lie on the Hicksian demand curve at u0. -/
theorem Claim_1_5_2_b (x0 x1 xs : ℝ) :
    let total_effect := x1 - x0
    let substitution_effect := xs - x0
    let income_effect := x1 - xs
    total_effect = substitution_effect + income_effect := by
  simp only
  ring