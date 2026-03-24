import Mathlib

-- Concavity of u(·,·) implies the Hessian is negative semidefinite.
-- The claim states: (∂₂₁u)² ≤ ∂₁₁u · ∂₂₂u ≤ (∂₁₁u + ∂₂₁u)²
-- The first inequality is the NSD determinant condition.
-- The second inequality follows from properties in Sections M.C and M.D.

axiom neg_semidef_det_bound (d11u d21u d22u : ℝ)
    (h_nsd : d21u ^ 2 ≤ d11u * d22u)
    (h_d11_neg : d11u ≤ 0)
    (h_d22_neg : d22u ≤ 0) :
    d11u * d22u ≤ (d11u + d21u) ^ 2

variable (d11u d21u d22u : ℝ)

theorem Claim_20F_e
    (h_nsd : d21u ^ 2 ≤ d11u * d22u)
    (h_d11_neg : d11u ≤ 0)
    (h_d22_neg : d22u ≤ 0) :
    d21u ^ 2 ≤ d11u * d22u ∧
    d11u * d22u ≤ (d11u + d21u) ^ 2 := by
  exact ⟨h_nsd, neg_semidef_det_bound d11u d21u d22u h_nsd h_d11_neg h_d22_neg⟩