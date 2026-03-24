import Mathlib

open Finset BigOperators
open BigOperators

/-- Aggregate law of supply: if each firm j satisfies (p - p') · (yⱼ(p) - yⱼ(p')) ≥ 0,
    then summing over firms gives (p - p') · (y(p) - y(p')) ≥ 0.
    Here δ j represents the dot product (p - p') · (yⱼ(p) - yⱼ(p')) for firm j. -/
theorem aggregate_law_of_supply
    {J : Type*} [Fintype J] [DecidableEq J]
    (δ : J → ℝ)
    (hδ : ∀ j, 0 ≤ δ j) :
    0 ≤ ∑ j : J, δ j :=
  Finset.sum_nonneg fun j _ => hδ j