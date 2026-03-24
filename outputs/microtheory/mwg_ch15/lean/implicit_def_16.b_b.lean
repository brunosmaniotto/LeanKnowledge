import Mathlib

open Finset BigOperators
open BigOperators

/-- A private ownership economy with I consumers, J firms, and L commodities. -/
structure PrivateOwnershipEconomy (I J L : Type*) [Fintype I] [Fintype J] [Fintype L] where
  /-- Consumption set for each consumer -/
  consumptionSet : I → Set (L → ℝ)
  /-- Preference relation for each consumer -/
  pref : I → (L → ℝ) → (L → ℝ) → Prop
  /-- Production set for each firm -/
  productionSet : J → Set (L → ℝ)
  /-- Endowment vector for each consumer -/
  endowment : I → (L → ℝ)
  /-- Profit share of consumer i in firm j -/
  share : I → J → ℝ
  /-- Shares are in [0,1] -/
  share_nonneg : ∀ i j, 0 ≤ share i j
  share_le_one : ∀ i j, share i j ≤ 1
  /-- For every firm j, shares across consumers sum to 1 -/
  share_sum_one : ∀ j, ∑ i : I, share i j = 1

/-- Aggregate endowment of a private ownership economy -/
noncomputable def PrivateOwnershipEconomy.aggregateEndowment
    {I J L : Type*} [Fintype I] [Fintype J] [Fintype L]
    (E : PrivateOwnershipEconomy I J L) : L → ℝ :=
  fun l => ∑ i : I, E.endowment i l