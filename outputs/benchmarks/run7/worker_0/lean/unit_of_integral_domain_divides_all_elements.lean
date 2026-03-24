import Mathlib

variable {D : Type*} [CommRing D] [IsDomain D]

theorem units_dvd_every_element (u : Dˣ) (x : D) : (u : D) ∣ x := by
  use u.inv * x
  simp [mul_assoc]