import Mathlib

open Matrix
open Topology

/-- Theorem 1.16 (Jehle & Reny): The Slutsky matrix s(p, y) is symmetric
    and negative semidefinite.
    Proof: By the Slutsky equation (Thm 1.11), each entry of s equals the
    corresponding entry of the Hicksian substitution matrix σ(p, v(p,y)).
    By Thm 1.14 σ is symmetric and by Thm 1.15 σ is negative semidefinite,
    so s inherits both properties. -/
theorem Theorem_1_16
    {n : ℕ}
    (s σ : Matrix (Fin n) (Fin n) ℝ)
    -- Slutsky equation (Theorem 1.11): s_ij = σ_ij for all i, j
    (h_slutsky_eq : s = σ)
    -- Theorem 1.14: the Hicksian substitution matrix is symmetric
    (h_sym : σ.IsSymm)
    -- Theorem 1.15: the Hicksian substitution matrix is negative semidefinite
    (h_nsd : ∀ v : Fin n → ℝ, dotProduct v (σ.mulVec v) ≤ 0) :
    s.IsSymm ∧ ∀ v : Fin n → ℝ, dotProduct v (s.mulVec v) ≤ 0 := by
  subst h_slutsky_eq
  exact ⟨h_sym, h_nsd⟩