import Mathlib

open Real
open Topology

/-- In a Bertrand duopoly with market demand Q = α - βp, identical marginal cost c,
    firm 1 having fixed costs F > 0 and firm 2 having no fixed costs,
    a Bertrand equilibrium exists. Firm 2 prices at marginal cost c and serves
    the market; firm 1 cannot profitably undercut due to fixed costs. -/
theorem Exercise_4_12_a
    (α β c F : ℝ)
    (hβ : β > 0)
    (hF : F > 0)
    (hc : c ≥ 0)
    (hα : α > β * c) -- ensures positive demand at cost
    : ∃ (p₁ p₂ q₁ q₂ : ℝ),
      -- Equilibrium prices are at least marginal cost
      p₁ ≥ c ∧ p₂ = c ∧
      -- Firm 2 serves entire market at price c
      q₂ = α - β * c ∧ q₂ > 0 ∧
      -- Firm 1 gets no demand (priced out)
      q₁ = 0 ∧
      -- Firm 2's profit is zero (price = cost, no fixed costs)
      (p₂ - c) * q₂ = 0 ∧
      -- Firm 1 cannot profit by deviating: any price p < c yields negative
      -- profit due to fixed costs, and any price p ≥ c yields zero quantity
      (p₁ - c) * q₁ - F ≤ 0 := by
  refine ⟨c, c, 0, α - β * c, le_refl c, rfl, rfl, ?_, rfl, ?_, ?_⟩
  · linarith
  · ring
  · linarith