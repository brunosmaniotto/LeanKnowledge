import Mathlib

theorem divisor_of_unit_is_unit (D : Type) [CommRing D] [IsDomain D] (x u : D) (hu : IsUnit u) (h : x ∣ u) : IsUnit x :=
  isUnit_of_dvd_unit h hu