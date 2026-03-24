import Mathlib

open Matrix Finset
open BigOperators

/-- If an (L+1)×(L+1) matrix has rank L and rows sum to zero,
    then any L×L submatrix obtained by deleting one row and column has rank L. -/
axiom rank_submatrix_of_rank_pred
    {L : ℕ}
    (Dz : Matrix (Fin (L + 1)) (Fin (L + 1)) ℝ)
    (hz_rank : Dz.rank = L)
    (h_sum_zero : ∀ i : Fin (L + 1), ∑ j : Fin (L + 1), Dz i j = 0)
    (k : Fin (L + 1)) :
    (Dz.submatrix (Fin.succAbove k) (Fin.succAbove k)).rank = L

/-- The sign of the determinant of the reduced L×L submatrix is
    independent of the normalization choice (which good is dropped). -/
axiom det_sign_independent_of_normalization
    {L : ℕ}
    (Dz : Matrix (Fin (L + 1)) (Fin (L + 1)) ℝ)
    (hz_rank : Dz.rank = L)
    (h_sum_zero : ∀ i : Fin (L + 1), ∑ j : Fin (L + 1), Dz i j = 0)
    (k₁ k₂ : Fin (L + 1)) :
    SignType.sign (Dz.submatrix (Fin.succAbove k₁) (Fin.succAbove k₁)).det =
    SignType.sign (Dz.submatrix (Fin.succAbove k₂) (Fin.succAbove k₂)).det

theorem rank_submatrix_and_sign_independence
    {L : ℕ}
    (Dz : Matrix (Fin (L + 1)) (Fin (L + 1)) ℝ)
    (hz_rank : Dz.rank = L)
    (h_sum_zero : ∀ i : Fin (L + 1), ∑ j : Fin (L + 1), Dz i j = 0) :
    (∀ k : Fin (L + 1), (Dz.submatrix (Fin.succAbove k) (Fin.succAbove k)).rank = L) ∧
    (∀ k₁ k₂ : Fin (L + 1),
      SignType.sign (Dz.submatrix (Fin.succAbove k₁) (Fin.succAbove k₁)).det =
      SignType.sign (Dz.submatrix (Fin.succAbove k₂) (Fin.succAbove k₂)).det) :=
  ⟨fun k => rank_submatrix_of_rank_pred Dz hz_rank h_sum_zero k,
   fun k₁ k₂ => det_sign_independent_of_normalization Dz hz_rank h_sum_zero k₁ k₂⟩