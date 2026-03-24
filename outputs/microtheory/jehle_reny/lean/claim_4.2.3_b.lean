import Mathlib

open scoped Real

variable {Firm : Type} (profit : Firm → ℝ)
variable (IsLongRunMonopolisticCompetitionEquilibrium : Prop)

/-- Claim 4.2.3(b): In long-run monopolistic competition equilibrium, maximum achievable
    profits of all firms (active and potential entrants) must be non-positive,
    and the profits of every active firm must be exactly zero. -/
theorem Claim_4_2_3_b
    (h_long_run_equilibrium : IsLongRunMonopolisticCompetitionEquilibrium)
    (h_claim_4_1_g_result : IsLongRunMonopolisticCompetitionEquilibrium → (∀ (f : Firm), profit f = 0)) :
    (∀ (f : Firm), profit f ≤ 0) ∧ (∀ (f : Firm), profit f = 0) :=
by
  have h_zero_profit_all_firms : ∀ (f : Firm), profit f = 0 := h_claim_4_1_g_result h_long_run_equilibrium
  constructor
  intro f
  exact le_of_eq (h_zero_profit_all_firms f)
  intro f
  exact h_zero_profit_all_firms f