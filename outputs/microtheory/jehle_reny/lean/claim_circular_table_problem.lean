import Mathlib

open BigOperators

variable {I : Type} (T : I → Type)
variable (c_VCG : I → (∀ i, T i) → ℝ)
variable (minParticipationSubsidy : I → ℝ)

theorem Claim_circular_table_problem
    (h_cost_nonneg : ∀ i t, 0 ≤ c_VCG i t)
    (h_exists_positive_subsidy : ∃ i, 0 < minParticipationSubsidy i)
    (h_exists_non_pivotal : ∀ i, ∃ t, c_VCG i t = 0) :
    ∃ (i : I) (t : ∀ i, T i), c_VCG i t - minParticipationSubsidy i < 0 := by
  rcases h_exists_positive_subsidy with ⟨i, hi⟩
  rcases h_exists_non_pivotal i with ⟨t, hc⟩
  use i, t
  rw [hc]
  linarith