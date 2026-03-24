import Mathlib

/-- The 2×2 production model: two outputs produced from two primary factors,
    with constant-returns-to-scale production functions. -/
structure TwoByTwoProductionModel where
  /-- Production function for output 1, taking inputs (z₁₁, z₂₁) -/
  f₁ : ℝ → ℝ → ℝ
  /-- Production function for output 2, taking inputs (z₁₂, z₂₂) -/
  f₂ : ℝ → ℝ → ℝ
  /-- f₁ is homogeneous of degree one (constant returns to scale) -/
  f₁_homogeneous : ∀ (t z₁ z₂ : ℝ), f₁ (t * z₁) (t * z₂) = t * f₁ z₁ z₂
  /-- f₂ is homogeneous of degree one (constant returns to scale) -/
  f₂_homogeneous : ∀ (t z₁ z₂ : ℝ), f₂ (t * z₁) (t * z₂) = t * f₂ z₁ z₂