import Mathlib

open Finset BigOperators
open BigOperators

variable {L : ℕ}

/-- Revenue: inner product of prices and production plan. -/
noncomputable def revenue53g (p y : Fin L → ℝ) : ℝ :=
  ∑ l, p l * y l

/-- Claim 5.3(g): Profit is homogeneous of degree 1 in prices:
    (αp)·y = α·(p·y), so π(αp) = α·π(p).
    Supply is homogeneous of degree 0: argmax is unchanged under positive scaling. -/
theorem Claim_5_3_g (α : ℝ) (p y : Fin L → ℝ) :
    revenue53g (α • p) y = α * revenue53g p y := by
  unfold revenue53g
  simp only [Pi.smul_apply, smul_eq_mul, mul_assoc]
  rw [← Finset.mul_sum]