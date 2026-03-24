import Mathlib

open Set

theorem convex_nonneg_orthant (L : ℕ) :
    Convex ℝ {x : Fin L → ℝ | ∀ i, 0 ≤ x i} := by
  intro x hx y hy a b ha hb _
  intro i
  exact add_nonneg (mul_nonneg ha (hx i)) (mul_nonneg hb (hy i))