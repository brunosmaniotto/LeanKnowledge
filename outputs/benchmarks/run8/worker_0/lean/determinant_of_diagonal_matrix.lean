import Mathlib

open Matrix
open BigOperators

variable {n : Type} [Fintype n] [DecidableEq n] {R : Type} [CommRing R]

theorem det_diagonal_matrix (A : Matrix n n R) (h : ∀ i j, i ≠ j → A i j = 0) :
    det A = ∏ i, A i i := by
  have hA : A = diagonal (fun i => A i i) := by
    ext i j
    simp only [diagonal_apply]
    by_cases hij : i = j
    · subst hij
      simp
    · rw [if_neg hij, h i j hij]
  rw [hA, det_diagonal]
  simp