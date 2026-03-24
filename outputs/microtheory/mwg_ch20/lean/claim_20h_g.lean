import Mathlib

/-- If a real asset exists (ε > 0), then a bubble cannot occur at equilibrium.
    We model this as: given a positive real asset value ε and a bubble value b,
    if the equilibrium condition requires b ≤ 0 and b ≥ 0 (no-arbitrage + transversality),
    then b = 0. -/
theorem bubble_cannot_occur_with_real_asset
    (ε : ℝ) (hε : ε > 0)
    (b : ℝ)
    (h_nonneg : b ≥ 0)
    (h_transversality : b ≤ 0) :
    b = 0 := by
  linarith