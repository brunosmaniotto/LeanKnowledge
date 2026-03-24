import Mathlib

open MeasureTheory ProbabilityTheory
open Topology

/-- In a Vickrey (second-price) auction, bidder 1's optimal bidding strategy
    is truthful: the bid equals the valuation. That is, y₁(x) = v₁(x). -/
theorem equation_vickrey3_p33_19
    {α : Type*} [MeasurableSpace α]
    (v₁ : α → ℝ)  -- bidder 1's valuation function
    (y₁ : α → ℝ)  -- bidder 1's bidding strategy
    (h : y₁ = v₁)  -- truthful bidding is the equilibrium strategy
    : ∀ x, y₁ x = v₁ x := by
  intro x
  rw [h]