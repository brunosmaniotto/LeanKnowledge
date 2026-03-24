import Mathlib

open Complex

theorem gamma_difference_equation (z : ℂ) (hz : z ≠ 0) : Gamma (z + 1) = z * Gamma z :=
  Gamma_add_one z hz