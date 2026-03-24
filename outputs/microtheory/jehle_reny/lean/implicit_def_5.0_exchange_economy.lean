import Mathlib
open Topology

/-- An exchange economy ℰ = (≿ⁱ, eⁱ)_{i∈I} with a finite set of consumers I
    and n goods. Each consumer has a preference relation over the non-negative
    orthant ℝ^n₊ and a non-negative endowment vector. There is no production. -/
structure ExchangeEconomy (I : Type*) [Fintype I] (n : ℕ) where
  /-- Preference relation ≿ⁱ for consumer i over consumption bundles in ℝ^n₊ -/
  pref : I → (Fin n → ℝ) → (Fin n → ℝ) → Prop
  /-- Endowment vector eⁱ for consumer i -/
  endowment : I → Fin n → ℝ
  /-- Endowments are non-negative: eⁱ ∈ ℝ^n₊ -/
  endowment_nonneg : ∀ i, ∀ k, 0 ≤ endowment i k