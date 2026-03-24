import Mathlib

open Matrix

theorem det_of_first_row_unit_zeros {R : Type} [CommRing R] {n : ℕ} (A : Matrix (Fin (n + 1)) (Fin (n + 1)) R)
    (h0 : A 0 0 = 1) (h : ∀ j, j ≠ 0 → A 0 j = 0) :
    det A = det (A.submatrix (Fin.succAbove 0) (Fin.succAbove 0)) := by
  have h' : ∀ i : Fin n, A 0 (Fin.succ i) = 0 := fun i => h (Fin.succ i) (Fin.succ_ne_zero i)
  rw [det_succ_row A 0, Fin.sum_univ_succ]
  simp [h0, h']