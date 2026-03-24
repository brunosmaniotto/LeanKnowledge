import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Signal σ' is at least as informative as σ if σ-measurability implies σ'-measurability -/
theorem Proposition_19H1
    {S : Type*} [Fintype S] [DecidableEq S]
    (π : S → ℝ) (u : S → ℝ → ℝ)
    (Bσ Bσ' : Set (S → ℝ))
    (h_subset : Bσ ⊆ Bσ')
    (xσ : S → ℝ) (hxσ : xσ ∈ Bσ)
    (hxσ_opt : ∀ x ∈ Bσ, ∑ s : S, π s * u s (x s) ≤ ∑ s : S, π s * u s (xσ s))
    (xσ' : S → ℝ) (hxσ' : xσ' ∈ Bσ')
    (hxσ'_opt : ∀ x ∈ Bσ', ∑ s : S, π s * u s (x s) ≤ ∑ s : S, π s * u s (xσ' s)) :
    ∑ s : S, π s * u s (xσ s) ≤ ∑ s : S, π s * u s (xσ' s) := by
  have h1 : xσ ∈ Bσ' := h_subset hxσ
  exact hxσ'_opt xσ h1