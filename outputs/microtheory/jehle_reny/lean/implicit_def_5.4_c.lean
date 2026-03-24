import Mathlib

open BigOperators
open Topology

/-- A contingent consumption plan for consumer i in the contingent commodity framework.
    Specifies consumption of each of N basic goods contingent on each of M date-state
    pairs, forming a vector in ℝ^{NM}₊. It is the utility-maximizing affordable
    consumption bundle given prices p* and income mᵢ(p*). -/
structure ContingentConsumptionPlan (N M : ℕ) (u : (Fin N → Fin M → ℝ) → ℝ)
    (p : Fin N → Fin M → ℝ) (m : ℝ) where
  /-- The consumption bundle: x̂ᵢ(k, s) is consumption of good k in date-state s -/
  bundle : Fin N → Fin M → ℝ
  /-- Non-negativity: x̂ᵢ ∈ ℝ^{NM}₊ -/
  nonneg : ∀ k s, 0 ≤ bundle k s
  /-- Affordability: p* · x̂ᵢ ≤ mᵢ(p*) -/
  affordable : ∑ k : Fin N, ∑ s : Fin M, p k s * bundle k s ≤ m
  /-- Utility maximization over the affordable non-negative bundles -/
  optimal : ∀ y : Fin N → Fin M → ℝ,
    (∀ k s, 0 ≤ y k s) →
    ∑ k : Fin N, ∑ s : Fin M, p k s * y k s ≤ m →
    u y ≤ u bundle