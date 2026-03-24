import Mathlib

open Matrix

theorem adjugate_det_eq_pow {α : Type} [CommRing α] (n : ℕ) (A : Matrix (Fin n) (Fin n) α) :
    det (adjugate A) = (det A) ^ (n - 1) := by
  rw [det_adjugate, Fintype.card_fin]