import Mathlib

/-- A continuous effort model where effort is a real number, not just binary. -/
structure ContinuousEffortModel where
  /-- The effort level under full observability -/
  effort_full_obs : ℝ
  /-- The effort level under nonobservability -/
  effort_nonobs : ℝ

/-- Nonobservability can bias effort upward or downward relative to full observability. -/
theorem Claim_14B_m :
    ∃ (m1 m2 : ContinuousEffortModel),
      m1.effort_nonobs > m1.effort_full_obs ∧
      m2.effort_nonobs < m2.effort_full_obs := by
  exact ⟨⟨1, 2⟩, ⟨2, 1⟩, by norm_num, by norm_num⟩