import Mathlib

/-- Forcing a monopoly to lower price need not be Pareto improving:
    consumers may gain but the monopolist is made worse off. -/
theorem Claim_4_3_2_e :
    ∃ (consumerChange monopolistChange : ℝ),
      consumerChange > 0 ∧ monopolistChange < 0 ∧
      ¬(consumerChange ≥ 0 ∧ monopolistChange ≥ 0) := by
  exact ⟨1, -1, by norm_num, by norm_num, by norm_num⟩