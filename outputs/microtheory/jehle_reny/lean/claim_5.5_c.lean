import Mathlib
open Topology

/-- Edgeworth's conjecture (Debreu-Scarf 1963):
    As an economy is replicated, the core shrinks to the set of Walrasian equilibria. -/
theorem Claim_5_5_c
    {Allocation : Type*}
    (isWalrasian : Allocation → Prop)
    (coreOfReplica : ℕ → Set Allocation)
    (walrasian_in_core : ∀ x, isWalrasian x → ∀ n, x ∈ coreOfReplica n)
    (debreu_scarf : ∀ x, ¬isWalrasian x → ∃ N, ∀ n, N ≤ n → x ∉ coreOfReplica n) :
    ⋂ n, coreOfReplica n = {x | isWalrasian x} := by
  ext x
  simp only [Set.mem_iInter, Set.mem_setOf_eq]
  constructor
  · intro hx
    by_contra h
    obtain ⟨N, hN⟩ := debreu_scarf x h
    exact hN N le_rfl (hx N)
  · exact walrasian_in_core x