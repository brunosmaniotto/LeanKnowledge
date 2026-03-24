import Mathlib

variable {D : Type} [CommRing D] [IsDomain D]

theorem divisor_trans (x y z : D) (hxy : x ∣ y) (hyz : y ∣ z) : x ∣ z := by
  rcases hxy with ⟨s, hs⟩
  rcases hyz with ⟨t, ht⟩
  use s * t
  calc
    z = y * t := ht
    _ = (x * s) * t := by rw [hs]
    _ = x * (s * t) := by rw [mul_assoc]