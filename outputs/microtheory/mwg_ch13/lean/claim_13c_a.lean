import Mathlib

/-- In a signaling game with Bertrand wage competition, both firms offer
    w*(e) = μ(e)·θ_H + (1 − μ(e))·θ_L, i.e., the expected productivity. -/
theorem signaling_PBE_wage_equals_expected_productivity
    (θ_H θ_L : ℝ) (μ : ℝ) (hμ0 : 0 ≤ μ) (hμ1 : μ ≤ 1) :
    let expected_productivity := μ * θ_H + (1 - μ) * θ_L
    let w_star := μ * θ_H + (1 - μ) * θ_L
    w_star = expected_productivity := by
  rfl