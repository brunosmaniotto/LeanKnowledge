import Mathlib
open Topology

/-- In the two-bidder case, the maximum bid must be the same for both bidders.
    Any bid above the opponent's maximum can be reduced with profit: bidding
    lower while still guaranteeing a win yields higher profit (v - b). -/
theorem claim_vickrey3_p34_g
    (v₁ v₂ : ℝ)           -- bidder valuations
    (max₁ max₂ : ℝ)       -- maximum (optimal) bids
    -- Optimality: max₁ maximizes profit v₁ - b among winning bids (b ≥ max₂)
    (opt₁ : ∀ b : ℝ, b ≥ max₂ → v₁ - b ≤ v₁ - max₁)
    -- Optimality: max₂ maximizes profit v₂ - b among winning bids (b ≥ max₁)
    (opt₂ : ∀ b : ℝ, b ≥ max₁ → v₂ - b ≤ v₂ - max₂)
    : max₁ = max₂ := by
  -- From opt₁ with b = max₂: v₁ - max₂ ≤ v₁ - max₁, so max₁ ≤ max₂
  have h₁ : max₁ ≤ max₂ := by linarith [opt₁ max₂ (le_refl max₂)]
  -- From opt₂ with b = max₁: v₂ - max₁ ≤ v₂ - max₂, so max₂ ≤ max₁
  have h₂ : max₂ ≤ max₁ := by linarith [opt₂ max₁ (le_refl max₁)]
  linarith