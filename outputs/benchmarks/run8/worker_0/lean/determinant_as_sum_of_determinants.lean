import Mathlib

open Matrix

variable {R : Type u} [CommRing R] {n : Type v} [DecidableEq n] [Fintype n]

theorem det_add_row (M : Matrix n n R) (r : n) (a' : n → R) :
    (M.updateRow r (M r + a')).det = M.det + (M.updateRow r a').det := by
  rw [det_updateRow_add]
  simp