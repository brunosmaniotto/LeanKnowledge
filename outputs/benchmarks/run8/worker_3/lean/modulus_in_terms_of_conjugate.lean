import Mathlib

theorem Modulus_in_Terms_of_Conjugate (z : ℂ) : (↑(‖z‖ ^ 2) : ℂ) = z * star z := by
  simp [Complex.mul_conj, Complex.normSq_eq_norm_sq]