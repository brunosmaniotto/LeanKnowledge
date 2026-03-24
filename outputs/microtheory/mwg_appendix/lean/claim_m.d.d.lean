import Mathlib

open Matrix
open Topology

theorem claim_M_D_d {n : ℕ} (M : Matrix (Fin n) (Fin n) ℝ) :
    (∀ x : Fin n → ℝ, 0 ≤ x ⬝ᵥ M *ᵥ x) ↔
      (∀ x : Fin n → ℝ, x ⬝ᵥ (-M) *ᵥ x ≤ 0) := by
  constructor
  · intro h x
    simp only [neg_mulVec, dotProduct_neg]
    linarith [h x]
  · intro h x
    have := h x
    simp only [neg_mulVec, dotProduct_neg] at this
    linarith