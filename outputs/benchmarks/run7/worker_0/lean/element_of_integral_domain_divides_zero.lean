import Mathlib

theorem element_divides_zero (D : Type _) [CommRing D] [IsDomain D] (x : D) : x ∣ (0 : D) :=
  dvd_zero x