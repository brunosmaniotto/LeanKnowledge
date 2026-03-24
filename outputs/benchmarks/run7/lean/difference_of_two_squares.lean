import Mathlib

theorem diff_sq (R : Type) [CommRing R] (x y : R) : x * x + (-(y * y)) = (x + y) * (x + (-y)) := by
  ring