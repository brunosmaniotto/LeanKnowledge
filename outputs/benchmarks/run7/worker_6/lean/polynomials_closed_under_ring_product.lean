import Mathlib

variable {J R : Type} [CommSemiring R]

theorem polynomial_product (f g : MvPolynomial J R) : Set.Finite {k | (f * g).coeff k ≠ 0} := by
  simpa [← MvPolynomial.mem_support_iff] using (f * g).support.finite_toSet