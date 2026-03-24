import Mathlib

open Matrix Finset BigOperators
open Topology

/-- Theorem 1.12: Own-substitution effects are non-positive (diagonal entries ≤ 0) -/
axiom theorem_1_12 {n : ℕ} (S : Matrix (Fin n) (Fin n) ℝ) (hS : ∀ v : Fin n → ℝ, dotProduct v (S.mulVec v) ≤ 0) :
    ∀ i : Fin n, S i i ≤ 0

/-- Theorem 1.14: The substitution matrix is symmetric -/
axiom theorem_1_14 {n : ℕ} (S : Matrix (Fin n) (Fin n) ℝ) (hS : ∀ v : Fin n → ℝ, dotProduct v (S.mulVec v) ≤ 0)
    (hSym : S.IsSymm) : ∀ i j : Fin n, S i j = S j i

/-- The substitution matrix has non-positive diagonal entries and is symmetric. -/
theorem Claim_1_5_2_f {n : ℕ} (S : Matrix (Fin n) (Fin n) ℝ)
    (hNSD : ∀ v : Fin n → ℝ, dotProduct v (S.mulVec v) ≤ 0)
    (hSym : S.IsSymm) :
    (∀ i : Fin n, S i i ≤ 0) ∧ (∀ i j : Fin n, S i j = S j i) := by
  exact ⟨theorem_1_12 S hNSD, theorem_1_14 S hNSD hSym⟩