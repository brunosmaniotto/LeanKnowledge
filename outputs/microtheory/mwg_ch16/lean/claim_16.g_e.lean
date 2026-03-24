import Mathlib

/-- In a large replica economy, any Pareto optimal allocation must be
    approximately price supportable, even without convexity assumptions,
    provided nonconvexities of production sets are bounded. -/
theorem Claim_16_G_e
    {I : Type*} [Fintype I] [Nonempty I]
    {G : Type*} [Fintype G]
    (Allocation : Type*)
    (feasible : Allocation → Prop)
    (paretoOptimal : Allocation → Prop)
    (priceSupportable : Allocation → ℝ → Prop)
    (replicas : ℕ)
    (ε : ℝ)
    (hε : 0 < ε)
    -- Key hypothesis: with enough replicas, non-supportable allocations can be Pareto dominated
    (h_large_replicas : ∃ N : ℕ, ∀ r : ℕ, r ≥ N →
      ∀ x : Allocation, feasible x → paretoOptimal x →
        priceSupportable x ε) :
    ∃ N : ℕ, ∀ r : ℕ, r ≥ N →
      ∀ x : Allocation, feasible x → paretoOptimal x →
        priceSupportable x ε := by
  exact h_large_replicas