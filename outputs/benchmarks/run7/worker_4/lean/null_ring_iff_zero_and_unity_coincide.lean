import Mathlib

theorem ring_subsingleton_iff_one_eq_zero (R : Type u) [Ring R] : Subsingleton R ↔ (1 : R) = 0 := by
  constructor
  · intro h
    exact h.elim 1 0
  · intro h
    have h1 : ∀ x : R, x = 0 := by
      intro x
      calc
        x = x * 1 := by rw [mul_one]
        _ = x * 0 := by rw [h]
        _ = 0 := by rw [mul_zero]
    exact ⟨fun a b => by rw [h1 a, h1 b]⟩