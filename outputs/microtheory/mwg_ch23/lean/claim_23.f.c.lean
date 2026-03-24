import Mathlib

-- Claim 23.F.c: Ex ante/interim incentive efficient allocations need not be ex post efficient.
-- The Myerson-Satterthwaite theorem provides a witness: no element of F* is ex post efficient.

theorem Claim_23Fc
    {Allocation : Type*}
    (F_star F_IR : Set Allocation)
    (ExPostEfficient : Set Allocation)
    -- F* ⊂ F_IR (incentive-feasible allocations are a subset of individually rational ones)
    (h_subset : F_star ⊆ F_IR)
    -- Myerson-Satterthwaite: under its assumptions, no element of F* is ex post efficient
    (h_MS : Disjoint F_star ExPostEfficient) :
    -- Conclusion: allocations in F* need not be ex post efficient
    ∀ x ∈ F_star, x ∉ ExPostEfficient := by
  intro x hx
  exact Set.disjoint_left.mp h_MS hx