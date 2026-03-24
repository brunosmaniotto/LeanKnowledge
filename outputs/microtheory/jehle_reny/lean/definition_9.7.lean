import Mathlib

open Finset BigOperators
open BigOperators

/-- Cost functions c₁,...,cₙ are budget-balanced if they sum to zero
    for every type profile: Σᵢ cᵢ(t) = 0 for all t ∈ T. -/
def BudgetBalancedCosts {N : ℕ} {T : Type*} (c : Fin N → T → ℝ) : Prop :=
  ∀ t : T, ∑ i : Fin N, c i t = 0