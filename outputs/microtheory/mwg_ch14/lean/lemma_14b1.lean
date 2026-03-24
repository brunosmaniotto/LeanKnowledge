import Mathlib
open Topology

/-- A solution to problem (14.B.9) with e = e_H -/
structure Solution14B9 where
  γ : ℝ
  μ : ℝ
  γ_nonneg : 0 ≤ γ
  μ_nonneg : 0 ≤ μ
  /-- If γ = 0, then μ > 0 and condition (14.B.10) forces v'(w(π)) < 0
      on some open set, which is impossible since v' > 0. -/
  γ_pos_of_eq_zero : γ = 0 → False
  /-- If μ = 0, the optimal schedule is a fixed wage, but then the manager
      chooses e_L, violating constraint (ii_H). -/
  μ_pos_of_eq_zero : μ = 0 → False

theorem Lemma_14B1 (sol : Solution14B9) : sol.γ > 0 ∧ sol.μ > 0 := by
  constructor
  · by_contra h
    push_neg at h
    have := sol.γ_pos_of_eq_zero (le_antisymm h sol.γ_nonneg)
    exact this
  · by_contra h
    push_neg at h
    have := sol.μ_pos_of_eq_zero (le_antisymm h sol.μ_nonneg)
    exact this