import Mathlib
open Topology
open BigOperators

/-- Budget set for consumer i: all bundles affordable at prices p given endowment ω_i. -/
def BudgetSet {L : Type*} [Fintype L] [DecidableEq L]
    (p : L → ℝ) (ω : L → ℝ) : Set (L → ℝ) :=
  {x | ∑ l, p l * x l ≤ ∑ l, p l * ω l}

/-- A Walrasian (competitive) equilibrium for a two-consumer Edgeworth box economy.

Given commodity space `L`, endowments `ω₁, ω₂`, and preference relations `pref₁, pref₂`,
a Walrasian equilibrium consists of a price vector `p` and allocations `x₁, x₂` such that:
1. The allocation is feasible (total demand = total endowment for each commodity).
2. Each consumer's bundle is in their budget set.
3. Each consumer's bundle is weakly preferred to every other bundle in their budget set. -/
structure WalrasianEquilibrium
    {L : Type*} [Fintype L] [DecidableEq L]
    (ω₁ ω₂ : L → ℝ)
    (pref₁ pref₂ : (L → ℝ) → (L → ℝ) → Prop) where
  /-- Equilibrium price vector -/
  p : L → ℝ
  /-- Consumer 1's equilibrium allocation -/
  x₁ : L → ℝ
  /-- Consumer 2's equilibrium allocation -/
  x₂ : L → ℝ
  /-- Feasibility: allocation sums to total endowment in each commodity -/
  feasible : ∀ l, x₁ l + x₂ l = ω₁ l + ω₂ l
  /-- Consumer 1's bundle is in their budget set -/
  budget₁ : x₁ ∈ BudgetSet p ω₁
  /-- Consumer 2's bundle is in their budget set -/
  budget₂ : x₂ ∈ BudgetSet p ω₂
  /-- Consumer 1 weakly prefers x₁ to all affordable bundles -/
  optimal₁ : ∀ x ∈ BudgetSet p ω₁, pref₁ x₁ x
  /-- Consumer 2 weakly prefers x₂ to all affordable bundles -/
  optimal₂ : ∀ x ∈ BudgetSet p ω₂, pref₂ x₂ x