import Mathlib

open Finset BigOperators
open BigOperators

/-- The no-production assumption in a pure exchange economy: the total supply
of each commodity ℓ is fixed at the sum of initial endowments Σ_{i∈I} eⁱ_ℓ.
Commodities exist but the model does not include a production sector. -/
def NoProduction {I : Type*} [Fintype I] {L : Type*} [Fintype L]
    (totalSupply : L → ℝ) (e : I → L → ℝ) : Prop :=
  ∀ ℓ, totalSupply ℓ = ∑ i, e i ℓ