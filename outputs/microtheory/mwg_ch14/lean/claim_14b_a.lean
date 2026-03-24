import Mathlib
open Topology

theorem reservation_utility_binds
    (u : ℝ → ℝ) (w ū : ℝ)
    (h_mono : StrictMono u)
    (h_cont : Continuous u)
    (h_slack : u w > ū) :
    ∃ w' : ℝ, w' < w ∧ u w' ≥ ū := by
  by_cases h : u (w - 1) ≥ ū
  · exact ⟨w - 1, by linarith, h⟩
  · push_neg at h
    have h1 : w - 1 < w := by linarith
    have h2 : u (w - 1) ≤ ū := le_of_lt h
    have h3 : ū ≤ u w := le_of_lt h_slack
    obtain ⟨w', hw'_mem, hw'_eq⟩ := intermediate_value_Icc (le_of_lt h1)
      h_cont.continuousOn ⟨h2, h3⟩
    refine ⟨w', ?_, ge_of_eq hw'_eq⟩
    rcases hw'_mem with ⟨_, hw'r⟩
    rcases lt_or_eq_of_le hw'r with h_lt | h_eq
    · exact h_lt
    · exfalso
      rw [h_eq] at hw'_eq
      linarith