import Mathlib
open Topology

/-- In the risky asset demand problem, if the expected return on the risky asset
exceeds the safe return (∫ z dF(z) > 1), then the optimal investment α* in the
risky asset is strictly positive.

The key mathematical argument: the derivative of expected utility at α=0 is
φ(0) = u'(w) · (E[z] - 1) > 0, so α* = 0 cannot satisfy the first-order
condition φ(α*) ≤ 0, hence α* > 0. -/
theorem risky_asset_positive_demand
    (φ : ℝ → ℝ)
    (α_star : ℝ)
    (hα_nonneg : α_star ≥ 0)
    (hφ0 : φ 0 > 0)
    (hfoc : φ α_star ≤ 0) :
    α_star > 0 := by
  by_contra h
  push_neg at h
  have : α_star = 0 := le_antisymm h hα_nonneg
  linarith [this ▸ hfoc]