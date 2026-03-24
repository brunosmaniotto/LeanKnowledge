import Mathlib
open Topology

/-- In the optimal high-effort policy under asymmetric information,
    both the participation constraint and incentive constraint bind.
    By complementary slackness, positive multipliers imply equality. -/
theorem claim_8_both_constraints_bind
    {participation_slack incentive_slack lam bet : ℝ}
    (h_comp_part : lam * participation_slack = 0)
    (h_comp_inc : bet * incentive_slack = 0)
    (hlam_pos : lam > 0)
    (hbet_pos : bet > 0) :
    participation_slack = 0 ∧ incentive_slack = 0 := by
  constructor
  · rcases mul_eq_zero.mp h_comp_part with h | h
    · linarith
    · exact h
  · rcases mul_eq_zero.mp h_comp_inc with h | h
    · linarith
    · exact h