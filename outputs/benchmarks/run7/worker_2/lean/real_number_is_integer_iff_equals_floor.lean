import Mathlib

theorem int_iff_eq_floor (x : ℝ) : x = (Int.floor x : ℝ) ↔ ∃ (z : ℤ), x = (z : ℝ) := by
  constructor
  · intro h
    exact ⟨Int.floor x, h⟩
  · rintro ⟨z, h⟩
    rw [h]
    simp