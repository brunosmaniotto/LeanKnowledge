import Mathlib
open Topology

/-- Neither the pure competitor nor the pure monopolist needs to consider
    other firms' actions when formulating profit-maximising plans.

    If a firm's profit is independent of competitors' actions — which holds
    for the perfect competitor (who cannot affect market price) and for the
    pure monopolist (who faces no competitors due to blocked entry) — then
    the profit-maximising output is invariant to those actions. -/
theorem Claim_4_2_e
    (profit : ℝ → ℝ → ℝ)  -- profit(own_quantity, others_actions)
    (h_indep : ∀ q a₁ a₂, profit q a₁ = profit q a₂)
    (q_star : ℝ) (a₀ : ℝ)
    (h_opt : ∀ q, profit q_star a₀ ≥ profit q a₀) :
    ∀ a q, profit q_star a ≥ profit q a := by
  intro a q
  rw [h_indep q_star a a₀, h_indep q a a₀]
  exact h_opt q