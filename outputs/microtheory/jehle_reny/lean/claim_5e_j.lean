import Mathlib

open Set

/-- Core of the r-replica economy, projected back to allocations of the original economy. -/
axiom Allocation : Type

/-- Core of the r-replica economy -/
axiom CoreR : ℕ → Set Allocation

/-- The set of Walrasian equilibrium allocations for E₁. -/
axiom WEA : Set Allocation

/-- Cores are nested: C₁ ⊇ C₂ ⊇ ... -/
axiom core_antitone : ∀ r : ℕ, r ≥ 1 → CoreR (r + 1) ⊆ CoreR r

/-- Lemma 5.4 + Theorem 5.5: any WEA for E₁ is in CoreR r for all r ≥ 1. -/
axiom wea_in_replica_core :
    ∀ (x : Allocation), x ∈ WEA → ∀ r : ℕ, r ≥ 1 → x ∈ CoreR r

/-- C₁ ⊇ C₂ ⊇ … ⊇ W₁(e): the set of Walrasian equilibrium allocations
    for E₁ is contained in every Cᵣ. -/
theorem Claim_5e_j : ∀ r : ℕ, r ≥ 1 → WEA ⊆ CoreR r := by
  intro r hr x hx
  exact wea_in_replica_core x hx r hr