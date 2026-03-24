import Mathlib

variable (D : Type) [CommRing D] [IsDomain D]

theorem self_dvd (x : D) : x ∣ x :=
  ⟨1, by rw [mul_one]⟩