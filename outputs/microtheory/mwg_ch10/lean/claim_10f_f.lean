import Mathlib

open scoped Real

-- Fixed cost K, assumed to be non-negative.
variable (K : ℝ) (hK_nonneg : K ≥ 0)

-- Variable cost function ψ, assumed to produce non-negative costs.
variable (psi : ℝ → ℝ) (h_psi_nonneg : ∀ q, psi q ≥ 0)

-- Define the short-run total cost: K is sunk.
-- c_s(q) = K + ψ(q) for all q ≥ 0.
def shortRunTotalCost (q : ℝ) : ℝ := K + psi q

-- Define the long-run total cost: K is avoidable if q = 0.
-- c(q) = K + ψ(q) for q > 0, c(0) = 0.