import Mathlib

open Set
open Topology

variable (Allocation : Type*)

/-- The core of the r-replica economy -/
axiom C_r (Allocation : Type*) : ℕ → Set Allocation

/-- The set of Walrasian equilibrium allocations for the original economy -/
axiom W₁ (Allocation : Type*) : Set Allocation

/-- Claim 5e_j: Every Walrasian equilibrium allocation is in the core of every replica economy -/
axiom walrasian_in_core (Allocation : Type*) :
    ∀ (x : Allocation), x ∈ W₁ Allocation → ∀ r : ℕ, r ≥ 1 → x ∈ C_r Allocation r

/-- Core convergence (Theorem 5.17): Any allocation in the core of every replica economy
    is a Walrasian equilibrium allocation -/
axiom core_convergence (Allocation : Type*) :
    ∀ (x : Allocation), (∀ r : ℕ, r ≥ 1 → x ∈ C_r Allocation r) → x ∈ W₁ Allocation

theorem Claim_5e_q :
    (⋂ r ∈ {r : ℕ | r ≥ 1}, C_r Allocation r) = W₁ Allocation := by
  ext x
  simp only [mem_iInter, mem_setOf_eq]
  constructor
  · intro h
    exact core_convergence Allocation x h
  · intro h r hr
    exact walrasian_in_core Allocation x h r hr