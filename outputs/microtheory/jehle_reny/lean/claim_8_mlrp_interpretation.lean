import Mathlib
open Topology

/-- The Monotone Likelihood Ratio Property (MLRP) for accident insurance. -/
structure MLRP_Accident (π_low π_high : ℝ → ℝ) : Prop where
  ratio_increasing : ∀ l₁ l₂ : ℝ, l₁ < l₂ →
    π_low l₁ * π_high l₂ ≤ π_low l₂ * π_high l₁

/-- The MLRP implies that conditional on observing accident loss l, the relative
    probability that low effort was expended versus high effort increases with l. -/
theorem Claim_8_MLRP_interpretation
    (π_low π_high : ℝ → ℝ)
    (hMLRP : MLRP_Accident π_low π_high)
    (l₁ l₂ : ℝ) (hl : l₁ < l₂)
    (hpos₁ : 0 < π_high l₁) (hpos₂ : 0 < π_high l₂) :
    π_low l₁ / π_high l₁ ≤ π_low l₂ / π_high l₂ := by
  have h := hMLRP.ratio_increasing l₁ l₂ hl
  rwa [div_le_div_iff₀ hpos₁ hpos₂]