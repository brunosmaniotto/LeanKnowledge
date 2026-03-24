import Mathlib

theorem Theorem_M_J_1 {N : ℕ} (f : EuclideanSpace ℝ (Fin N) → ℝ)
    (x : EuclideanSpace ℝ (Fin N))
    (hd : DifferentiableAt ℝ f x)
    (hext : IsLocalMin f x ∨ IsLocalMax f x) :
    fderiv ℝ f x = 0 := by
  rcases hext with hmin | hmax
  · exact IsLocalMin.fderiv_eq_zero hmin
  · exact IsLocalMax.fderiv_eq_zero hmax