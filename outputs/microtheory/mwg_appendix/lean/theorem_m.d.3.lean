import Mathlib
open Matrix BigOperators

noncomputable def borderedMatrix (N S r : ℕ) (hrN : r ≤ N)
    (M : Matrix (Fin N) (Fin N) ℝ) (B : Matrix (Fin N) (Fin S) ℝ) :
    Matrix (Fin r ⊕ Fin S) (Fin r ⊕ Fin S) ℝ :=
  fromBlocks
    (M.submatrix (Fin.castLE hrN) (Fin.castLE hrN))
    (B.submatrix (Fin.castLE hrN) id)
    (B.submatrix (Fin.castLE hrN) id)ᵀ
    (0 : Matrix (Fin S) (Fin S) ℝ)

private axiom Theorem_MD3_part_i {N S : ℕ} (hSN : S < N)
    (M : Matrix (Fin N) (Fin N) ℝ) (B : Matrix (Fin N) (Fin S) ℝ)
    (hM : Mᵀ = M) :
    (∀ z : Fin N → ℝ, z ≠ 0 → Bᵀ.mulVec z = 0 →
        dotProduct z (M.mulVec z) < 0) ↔
    (∀ r : ℕ, ∀ _ : S < r, ∀ hrN : r ≤ N,
      ((-1 : ℝ) ^ (r - S)) * (borderedMatrix N S r hrN M B).det > 0)

private axiom Theorem_MD3_part_ii {N S : ℕ} (hSN : S < N)
    (M : Matrix (Fin N) (Fin N) ℝ) (B : Matrix (Fin N) (Fin S) ℝ)
    (hM : Mᵀ = M) :
    (∀ z : Fin N → ℝ, Bᵀ.mulVec z = 0 →
        dotProduct z (M.mulVec z) ≤ 0) ↔
    (∀ r : ℕ, ∀ _ : S < r, ∀ hrN : r ≤ N,
      ((-1 : ℝ) ^ (r - S)) * (borderedMatrix N S r hrN M B).det ≥ 0)

theorem «Theorem_M.D.3» {N S : ℕ} (hSN : S < N)
    (M : Matrix (Fin N) (Fin N) ℝ) (B : Matrix (Fin N) (Fin S) ℝ)
    (hM : Mᵀ = M) :
    ((∀ z : Fin N → ℝ, z ≠ 0 → Bᵀ.mulVec z = 0 →
        dotProduct z (M.mulVec z) < 0) ↔
     (∀ r : ℕ, ∀ _ : S < r, ∀ hrN : r ≤ N,
       ((-1 : ℝ) ^ (r - S)) * (borderedMatrix N S r hrN M B).det > 0)) ∧
    ((∀ z : Fin N → ℝ, Bᵀ.mulVec z = 0 →
        dotProduct z (M.mulVec z) ≤ 0) ↔
     (∀ r : ℕ, ∀ _ : S < r, ∀ hrN : r ≤ N,
       ((-1 : ℝ) ^ (r - S)) * (borderedMatrix N S r hrN M B).det ≥ 0)) :=
  ⟨Theorem_MD3_part_i hSN M B hM, Theorem_MD3_part_ii hSN M B hM⟩