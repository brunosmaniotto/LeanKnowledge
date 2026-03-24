import Mathlib

open scoped BigOperators
open Topology

/-- If ε > 0 (real asset), then finiteness of generation 0's wealth
    (1 - ε) * p₀ + ε * S + M implies S (= Σ pₜ) is finite. -/
theorem Claim_20H_c
    (ε : ℝ) (hε : ε > 0)
    (p₀ M S : ℝ)
    (hwealth : ∃ W : ℝ, W = (1 - ε) * p₀ + ε * S + M) :
    ∃ W : ℝ, W = (1 - ε) * p₀ + ε * S + M ∧ S = (W - (1 - ε) * p₀ - M) / ε := by
  obtain ⟨W, hW⟩ := hwealth
  exact ⟨W, hW, by field_simp; linarith⟩