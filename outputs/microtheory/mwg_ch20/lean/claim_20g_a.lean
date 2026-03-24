import Mathlib
open Topology

/-- A multi-consumer economy can have multiple equilibria, each Pareto optimal
    but supported by different welfare weights in the associated planning problem. -/
theorem Claim_20G_a
    {n : ℕ} (hn : n ≥ 2)
    (Weight : Type*) [Fintype Weight]
    (Allocation : Type*)
    (isParetoOptimal : Allocation → Prop)
    (isEquilibrium : Allocation → Prop)
    (supportingWeight : Allocation → Weight)
    -- Every equilibrium is Pareto optimal (First Welfare Theorem)
    (first_welfare : ∀ a, isEquilibrium a → isParetoOptimal a)
    -- There exist two distinct equilibria with different weights
    (a₁ a₂ : Allocation)
    (h_eq₁ : isEquilibrium a₁)
    (h_eq₂ : isEquilibrium a₂)
    (h_diff_weights : supportingWeight a₁ ≠ supportingWeight a₂) :
    -- Both are Pareto optimal yet have different supporting weights
    isParetoOptimal a₁ ∧ isParetoOptimal a₂ ∧
    supportingWeight a₁ ≠ supportingWeight a₂ := by
  exact ⟨first_welfare a₁ h_eq₁, first_welfare a₂ h_eq₂, h_diff_weights⟩