import Mathlib

noncomputable def arrowPratt (u : ℝ → ℝ) (u' u'' : ℝ → ℝ) (x : ℝ) : ℝ :=
  -u'' x / u' x

theorem arrow_pratt_eq_four_pi_prime
    (u : ℝ → ℝ) (u' u'' : ℝ → ℝ) (x : ℝ)
    (pi_deriv_zero : ℝ)
    (hu' : u' x ≠ 0)
    (h_identity : 4 * pi_deriv_zero * u' x + u'' x = 0) :
    arrowPratt u u' u'' x = 4 * pi_deriv_zero := by
  unfold arrowPratt
  have h_u'' : u'' x = -(4 * pi_deriv_zero * u' x) := by linarith
  rw [h_u'']
  field_simp