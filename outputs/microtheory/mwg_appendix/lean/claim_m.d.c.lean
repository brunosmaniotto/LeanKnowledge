import Mathlib
open Topology

variable {n : Type*} [Fintype n] [DecidableEq n]

theorem claim_M_D_c (M : Matrix n n ℝ) :
    (∀ x : n → ℝ, x ≠ 0 → 0 < dotProduct x (M.mulVec x)) ↔
    (∀ x : n → ℝ, x ≠ 0 → dotProduct x ((-M).mulVec x) < 0) := by
  constructor
  · intro h x hx
    have h1 := h x hx
    simp [Matrix.neg_mulVec, dotProduct_neg]
    linarith
  · intro h x hx
    have h1 := h x hx
    simp [Matrix.neg_mulVec, dotProduct_neg] at h1
    linarith