import Mathlib

-- Claim A1.4c: If x3 bears the same coordinate-wise relation to x5 on L(y0)
-- as x1 does to x0, then monotonicity gives the same inequality for f(x3) vs y0.

theorem claim_A1_4_c {α β : Type*} [Preorder α] [Preorder β]
    (f : α → β) (x0 x5 x3 : α) (y0 : β)
    (hx0 : f x0 = y0) (hx5 : f x5 = y0)
    (hx3_gt : x5 < x3) :
    (StrictMono f → y0 < f x3) ∧ (StrictAnti f → f x3 < y0) := by
  constructor
  · intro hf
    rw [← hx5]
    exact hf hx3_gt
  · intro hf
    rw [← hx5]
    exact hf hx3_gt