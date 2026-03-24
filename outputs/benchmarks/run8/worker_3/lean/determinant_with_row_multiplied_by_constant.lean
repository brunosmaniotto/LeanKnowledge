import Mathlib

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n] {R : Type*} [CommRing R]

theorem det_row_mul_eq_mul (A : Matrix n n R) (i : n) (c : R) :
    det (A.updateRow i (c • A i)) = c * det A := by
  calc
    det (A.updateRow i (c • A i)) = c * det (A.updateRow i (A i)) := by
      rw [det_updateRow_smul]
    _ = c * det A := by
      simp [updateRow_self]