import Mathlib

/-- Marginal rate of substitution between benefit B and premium p
    for a consumer with utility function u over (B, p) space.
    MRS(B, p) = -(∂u/∂B) / (∂u/∂p), the slope of the indifference curve. -/
noncomputable def MRS (u : ℝ → ℝ → ℝ) (B p : ℝ) : ℝ :=
  -(deriv (fun b => u b p) B) / (deriv (u B) p)

/-- MRS for the low-risk consumer, parameterized by their utility over (B, p). -/
noncomputable def MRSl (ul : ℝ → ℝ → ℝ) (B p : ℝ) : ℝ := MRS ul B p

/-- MRS for the high-risk consumer, parameterized by their utility over (B, p). -/
noncomputable def MRSh (uh : ℝ → ℝ → ℝ) (B p : ℝ) : ℝ := MRS uh B p