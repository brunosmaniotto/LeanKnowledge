import Mathlib
open Topology

/-- Duality between utility maximization and expenditure minimization (MWG Claim 1.9a).
    Forward: a UMP solution also solves the EMP at utility level u(x*).
    Reverse: an EMP solution also solves the UMP at income y = cost(x*). -/
theorem Claim_1_9_a
    {X : Type*} (u : X → ℝ) (cost : X → ℝ) (xstar : X)
    -- Local nonsatiation: near any strictly cheaper bundle, one can improve utility within budget
    (hlns : ∀ x, cost x < cost xstar → ∃ x', u x' > u x ∧ cost x' ≤ cost xstar)
    -- Continuity: any bundle with strictly higher utility can be slightly cheapened
    (hcont : ∀ x, u x > u xstar → ∃ x', u x' > u xstar ∧ cost x' < cost x) :
    -- UMP optimality ↔ EMP optimality
    (∀ x, cost x ≤ cost xstar → u x ≤ u xstar) ↔
    (∀ x, u x ≥ u xstar → cost x ≥ cost xstar) := by
  constructor
  · -- Forward: UMP → EMP
    intro hump x hux
    by_contra h
    push_neg at h
    obtain ⟨x', hux', hcx'⟩ := hlns x h
    have h1 : u x' ≤ u xstar := hump x' hcx'
    linarith
  · -- Reverse: EMP → UMP
    intro hemp x hcx
    by_contra h
    push_neg at h
    obtain ⟨x', hux', hcx'⟩ := hcont x h
    have h1 : cost x' ≥ cost xstar := hemp x' (le_of_lt hux')
    linarith