import Mathlib

open Set

theorem separation_of_variables (g h : ℝ → ℝ) (y : ℝ → ℝ) (a b : ℝ)
    (hderiv : ∀ t ∈ uIcc a b, HasDerivAt y (g t * h (y t)) t)
    (hne : ∀ t ∈ uIcc a b, h (y t) ≠ 0) :
    ∫ t in a..b, deriv y t / h (y t) = ∫ t in a..b, g t := by
  refine intervalIntegral.integral_congr fun t ht => ?_
  have hderiv_t := hderiv t ht
  have hne_t := hne t ht
  rw [hderiv_t.deriv]
  field_simp [hne_t]