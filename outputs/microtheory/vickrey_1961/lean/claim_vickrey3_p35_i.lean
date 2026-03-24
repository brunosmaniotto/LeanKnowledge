import Mathlib
open Topology

/-- The bidding function y₂ ranges from y₂(r₂) = 0 to y₂(a - k) = 1
    by suitable choice of the constant of integration. -/
theorem claim_Vickrey3_p35_i (a k r₂ : ℝ) (h : r₂ < a - k) :
    ∃ y₂ : ℝ → ℝ, y₂ r₂ = 0 ∧ y₂ (a - k) = 1 := by
  exact ⟨fun x => (x - r₂) / (a - k - r₂), by simp, div_self (by linarith)⟩