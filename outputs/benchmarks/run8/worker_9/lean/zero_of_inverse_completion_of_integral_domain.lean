import Mathlib

variable {D : Type u} [CommRing D] [IsDomain D]

open IsLocalization

theorem zero_div_eq_zero (q : nonZeroDivisors D) : mk' (FractionRing D) (0 : D) q = 0 :=
  mk'_zero q