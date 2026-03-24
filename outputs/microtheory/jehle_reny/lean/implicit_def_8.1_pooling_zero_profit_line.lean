import Mathlib

/-- The pooling zero-profit line: policies (B, p) satisfying p = π̂·B,
    where π̂ = α·πL + (1−α)·πH is the population-weighted average loss probability. -/
def poolingZeroProfitLine (α πL πH : ℝ) : Set (ℝ × ℝ) :=
  {Bp : ℝ × ℝ | Bp.2 = (α * πL + (1 - α) * πH) * Bp.1}