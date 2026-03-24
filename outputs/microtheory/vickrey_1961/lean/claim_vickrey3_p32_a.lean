import Mathlib
open Topology

/-- In a symmetric two-bidder auction, Pareto optimality requires v₁ = v₂.
    Pareto optimality means the object goes to the higher-valued bidder.
    We encode this as: when bidder i draws value x and bidder j draws value y ≥ x,
    bidder j's bid must be at least bidder i's (so j wins, efficiently).
    At x = y, this gives v₁ x ≤ v₂ x and v₂ x ≤ v₁ x, hence equality. -/
theorem claim_Vickrey3_p32_a
    (v₁ v₂ : ℝ → ℝ)
    (h_eff₁ : ∀ x y, x ≤ y → v₁ x ≤ v₂ y)
    (h_eff₂ : ∀ x y, x ≤ y → v₂ x ≤ v₁ y) :
    ∀ x, v₁ x = v₂ x := by
  intro x
  have h1 := h_eff₁ x x le_rfl
  have h2 := h_eff₂ x x le_rfl
  linarith