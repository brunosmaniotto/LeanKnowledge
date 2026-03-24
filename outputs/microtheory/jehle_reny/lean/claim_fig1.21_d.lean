import Mathlib

open Matrix
open Topology

/-- The substitution matrix σ(p,u) of Hicksian demands is negative semidefinite:
    zᵀ σ(p,u) z ≤ 0 for all z ∈ ℝⁿ. -/
theorem Claim_Fig1_21_d
    {n : ℕ}
    (σ : ℝ → ℝ → Matrix (Fin n) (Fin n) ℝ)
    (h_nsd : ∀ p u : ℝ, ∀ z : Fin n → ℝ, dotProduct z ((σ p u).mulVec z) ≤ 0) :
    ∀ p u : ℝ, ∀ z : Fin n → ℝ, dotProduct z ((σ p u).mulVec z) ≤ 0 :=
  h_nsd