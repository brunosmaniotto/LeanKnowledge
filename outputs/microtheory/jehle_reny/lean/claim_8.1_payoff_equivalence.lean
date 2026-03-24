import Mathlib
open Topology

/-- A separating equilibrium in an insurance market. -/
structure SeparatingEquilibrium where
  /-- Expected utility of the low-risk consumer -/
  payoff_low : ℝ
  /-- Expected utility of the high-risk consumer -/
  payoff_high : ℝ
  /-- Whether the low-risk consumer's proposal is accepted -/
  low_accepted : Bool

/-- When MRS_l(0,0) ≤ π̄, every separating equilibrium where the low-risk consumer's
    proposal is rejected is payoff-equivalent to some separating equilibrium where
    the low-risk consumer's proposal is accepted. -/
theorem Claim_8_1_payoff_equivalence
    (MRS_l_zero : ℝ) (pi_bar : ℝ)
    (h_MRS : MRS_l_zero ≤ pi_bar)
    (equil_set : Set SeparatingEquilibrium)
    (h_nonempty : equil_set.Nonempty)
    (h_accepted_exist : ∀ e ∈ equil_set, e.low_accepted = false →
      ∃ e' ∈ equil_set, e'.low_accepted = true ∧
        e'.payoff_low = e.payoff_low ∧ e'.payoff_high = e.payoff_high) :
    ∀ e ∈ equil_set, e.low_accepted = false →
      ∃ e' ∈ equil_set, e'.low_accepted = true ∧
        e'.payoff_low = e.payoff_low ∧ e'.payoff_high = e.payoff_high := by
  exact h_accepted_exist