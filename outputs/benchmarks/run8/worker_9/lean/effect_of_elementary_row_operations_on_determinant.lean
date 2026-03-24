import Mathlib

open Matrix

variable {n : Type} [Fintype n] [DecidableEq n] {R : Type} [CommRing R]

theorem ero1_det (A : Matrix n n R) (i : n) (c : R) :
    (A.updateRow i (c • A i)).det = c * A.det := by
  rw [det_updateRow_smul A i c (A i)]
  simp [updateRow_self]