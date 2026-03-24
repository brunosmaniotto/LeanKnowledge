import Mathlib
open Topology

/-- For all (p, u), v(p, e(p, u)) ≥ u: the maximum utility at income equal to the
    minimum expenditure needed for utility u is at least u. -/
theorem Claim_1_4_3_b
    {n : ℕ}
    (X : Type*)                       -- consumption set
    (util : X → ℝ)                    -- utility function
    (cost : (Fin n → ℝ) → X → ℝ)     -- cost of bundle x at prices p
    (v : (Fin n → ℝ) → ℝ → ℝ)        -- indirect utility function
    (e : (Fin n → ℝ) → ℝ → ℝ)        -- expenditure function
    -- v(p, w) ≥ util(x) for any affordable bundle x (v is the supremum)
    (hv : ∀ p w x, cost p x ≤ w → util x ≤ v p w)
    -- e(p, u) affords a bundle achieving utility ≥ u
    (he : ∀ p u, ∃ x, cost p x ≤ e p u ∧ u ≤ util x)
    (p : Fin n → ℝ) (u : ℝ) :
    u ≤ v p (e p u) := by
  obtain ⟨x, hcost, hutil⟩ := he p u
  linarith [hv p (e p u) x hcost]