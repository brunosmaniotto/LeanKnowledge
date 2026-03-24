import Mathlib

theorem cancel_mul_nonzero {x y z : ℤ} (hx : x ≠ 0) : x * y = x * z ↔ y = z :=
  ⟨fun h => mul_left_cancel₀ hx h, fun h => by rw [h]⟩